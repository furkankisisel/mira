/*
  Cloud Function: deleteAccount
  - Accepts JSON { email: string }
  - Locates Firebase Auth user by email
  - Deletes user from Auth
  - Deletes all Firestore documents for that user under conventional collections
  - Handles CORS and returns structured JSON
  SECURITY: Consider validating ID tokens for real apps (not included here per requirements)
*/

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const cors = require('cors')({ origin: true });

// Initialize admin once
try {
    admin.initializeApp();
} catch (e) {
    // no-op if already initialized
}

const db = admin.firestore();

// Helper to delete a collection in batches
async function deleteCollection(collectionRef, batchSize = 200) {
    let query = collectionRef.limit(batchSize);
    while (true) {
        const snapshot = await query.get();
        if (snapshot.empty) break;
        const batch = db.batch();
        snapshot.docs.forEach((doc) => batch.delete(doc.ref));
        await batch.commit();
    }
}

// Helper to delete a document and its subcollections (depth-1)
async function deleteDocumentRecursive(docRef) {
    const subcollections = await docRef.listCollections();
    for (const sub of subcollections) {
        await deleteCollection(sub);
    }
    await docRef.delete();
}

exports.deleteAccount = functions.https.onRequest((req, res) => {
    cors(req, res, async () => {
        if (req.method !== 'POST') {
            return res.status(405).json({ error: 'Method Not Allowed' });
        }

        try {
            const { email } = req.body || {};
            if (!email || typeof email !== 'string') {
                return res.status(400).json({ error: 'Missing or invalid email' });
            }

            // Lookup user
            let userRecord;
            try {
                userRecord = await admin.auth().getUserByEmail(email);
            } catch (err) {
                if (err.code === 'auth/user-not-found') {
                    return res.status(404).json({ error: 'User not found' });
                }
                throw err;
            }

            const uid = userRecord.uid;

            // Firestore cleanup (adjust to your app schema)
            // Example structure:
            // users/{uid} + subcollections; habits/{uid}_*, visions/{uid}_*, transactions owned by uid, etc.
            // Below we clean a typical structure: users doc + all subcollections
            const userDocRef = db.collection('users').doc(uid);
            await deleteDocumentRecursive(userDocRef);

            // If you store per-user docs in other top-level collections, delete them here as well.
            // Example: await deleteCollection(db.collection('habits').where('uid', '==', uid));
            // Example: await deleteCollection(db.collection('visions').where('uid', '==', uid));
            // Example: await deleteCollection(db.collection('transactions').where('uid', '==', uid));

            // Delete from Auth last
            await admin.auth().deleteUser(uid);

            return res.status(200).json({ ok: true });
        } catch (err) {
            console.error('deleteAccount error:', err);
            return res.status(500).json({ error: 'Internal error' });
        }
    });
});

/*
  Cloud Function: sendBugReport
  - Accepts JSON { email: string, message: string, deviceInfo?: string }
  - Stores bug report in Firestore
  - Returns success response
*/
exports.sendBugReport = functions.https.onRequest((req, res) => {
    cors(req, res, async () => {
        if (req.method !== 'POST') {
            return res.status(405).json({ error: 'Method Not Allowed' });
        }

        try {
            const { email, message, deviceInfo } = req.body || {};

            if (!email || typeof email !== 'string') {
                return res.status(400).json({ error: 'Missing or invalid email' });
            }

            if (!message || typeof message !== 'string' || message.trim().length === 0) {
                return res.status(400).json({ error: 'Missing or invalid message' });
            }

            // Store bug report in Firestore
            const bugReportRef = await db.collection('bug_reports').add({
                email: email.trim(),
                message: message.trim(),
                deviceInfo: deviceInfo || 'Not provided',
                timestamp: admin.firestore.FieldValue.serverTimestamp(),
                status: 'new'
            });

            return res.status(200).json({
                ok: true,
                reportId: bugReportRef.id,
                message: 'Bug report submitted successfully'
            });
        } catch (err) {
            console.error('sendBugReport error:', err);
            return res.status(500).json({ error: 'Internal error' });
        }
    });
});

exports.setPremium = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    const { uid } = req.body || {};
    await admin.auth().setCustomUserClaims(uid, { premium: true });
    res.json({ ok: true });
  });
});

exports.removePremium = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    const { uid } = req.body || {};
    await admin.auth().setCustomUserClaims(uid, { premium: false });
    res.json({ ok: true });
  });
});

/**
 * Helper: send high-priority push notification to a list of user IDs via FCM multicast.
 * Excludes the author so they never receive notifications for their own actions.
 */
async function sendNotificationToUsers({ uids, excludeUid, title, body, data }) {
    const targetUids = (uids || []).filter((uid) => uid && uid !== excludeUid);
    if (targetUids.length === 0) return;

    // Fetch user documents to collect FCM device tokens
    const userDocs = await Promise.all(
        targetUids.map((uid) => db.collection('users').doc(uid).get())
    );

    const tokens = [];
    const tokenToUidMap = {};

    userDocs.forEach((doc, idx) => {
        if (doc.exists) {
            const userTokens = doc.data().fcmTokens || [];
            userTokens.forEach((t) => {
                if (typeof t === 'string' && t.trim().length > 0) {
                    tokens.push(t);
                    tokenToUidMap[t] = targetUids[idx];
                }
            });
        }
    });

    const uniqueTokens = Array.from(new Set(tokens));
    if (uniqueTokens.length === 0) return;

    // FCM Multicast payload with branded Mira styling & notification channels
    const message = {
        tokens: uniqueTokens,
        notification: {
            title: title,
            body: body,
        },
        data: Object.assign({}, data || {}, {
            title: title,
            body: body,
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
        }),
        android: {
            priority: 'high',
            notification: {
                channelId: 'social_interactions_v2',
                icon: 'ic_stat_mira',
                color: '#2E7D32',
                defaultSound: true,
                defaultVibrateTimings: true,
            },
        },
        apns: {
            payload: {
                aps: {
                    sound: 'default',
                    badge: 1,
                },
            },
        },
    };

    try {
        const response = await admin.messaging().sendEachForMulticast(message);
        console.log(`Multicast sent: ${response.successCount} success, ${response.failureCount} failed`);

        // Clean up unregistered or invalid tokens if any
        if (response.failureCount > 0) {
            const badTokens = [];
            response.responses.forEach((resp, idx) => {
                if (!resp.success) {
                    const errCode = resp.error ? resp.error.code : '';
                    if (
                        errCode === 'messaging/invalid-registration-token' ||
                        errCode === 'messaging/registration-token-not-registered'
                    ) {
                        badTokens.push(uniqueTokens[idx]);
                    }
                }
            });

            for (const t of badTokens) {
                const targetUid = tokenToUidMap[t];
                if (targetUid) {
                    await db.collection('users').doc(targetUid).update({
                        fcmTokens: admin.firestore.FieldValue.arrayRemove(t),
                    }).catch(() => {});
                }
            }
        }
    } catch (err) {
        console.error('Error sending FCM multicast notification:', err);
    }
}

/**
 * Trigger: When a member writes a note in a social room.
 * Sends push notifications to all other room members even if app is closed/terminated.
 */
exports.onRoomPostCreated = functions.firestore
    .document('rooms/{roomId}/posts/{postId}')
    .onCreate(async (snap, context) => {
        try {
            const post = snap.data();
            const { roomId, postId } = context.params;
            if (!post) return null;

            const authorUid = post.authorUid;
            const authorName = post.authorName || 'Bir üye';
            const content = post.content || '';

            const roomSnap = await db.collection('rooms').doc(roomId).get();
            if (!roomSnap.exists) return null;
            const roomData = roomSnap.data();
            const roomName = roomData.name || 'Sosyal Oda';
            const memberIds = roomData.memberIds || [];

            const title = `📝 ${authorName} • ${roomName}`;
            const body = content.length > 120 ? content.substring(0, 117) + '...' : content;

            await sendNotificationToUsers({
                uids: memberIds,
                excludeUid: authorUid,
                title: title,
                body: body,
                data: {
                    type: 'room_post',
                    roomId: roomId,
                    postId: postId,
                },
            });
            return null;
        } catch (err) {
            console.error('Error in onRoomPostCreated:', err);
            return null;
        }
    });

/**
 * Trigger: When a member sends a nudge (dürtme) to another member.
 * Sends push notification to the targeted user even if app is closed/terminated.
 */
exports.onRoomNudgeCreated = functions.firestore
    .document('rooms/{roomId}/nudges/{nudgeId}')
    .onCreate(async (snap, context) => {
        try {
            const nudge = snap.data();
            const { roomId, nudgeId } = context.params;
            if (!nudge) return null;

            const fromUid = nudge.fromUid;
            const toUid = nudge.toUid;
            const fromName = nudge.fromName || 'Bir üye';
            const message = nudge.message || 'Seni dürttü!';

            if (!toUid || toUid === fromUid) return null;

            const roomSnap = await db.collection('rooms').doc(roomId).get();
            const roomName = roomSnap.exists ? (roomSnap.data().name || 'Sosyal Oda') : 'Sosyal Oda';

            const title = `👊 ${fromName} seni dürtüyor!`;
            const body = `${roomName}: ${message}`;

            await sendNotificationToUsers({
                uids: [toUid],
                excludeUid: fromUid,
                title: title,
                body: body,
                data: {
                    type: 'room_nudge',
                    roomId: roomId,
                    nudgeId: nudgeId,
                },
            });
            return null;
        } catch (err) {
            console.error('Error in onRoomNudgeCreated:', err);
            return null;
        }
    });

/**
 * Trigger: When a member completes or progresses on a room habit.
 * Sends push notifications to other members to boost competition.
 */
exports.onRoomHabitProgressWritten = functions.firestore
    .document('rooms/{roomId}/habits/{habitId}/progress/{uid}')
    .onWrite(async (change, context) => {
        try {
            const before = change.before.exists ? change.before.data() : null;
            const after = change.after.exists ? change.after.data() : null;
            if (!after) return null;

            const { roomId, habitId, uid } = context.params;

            const wasCompleted = before ? (before.isCompleted === true) : false;
            const isNowCompleted = after.isCompleted === true;
            const prevVal = before ? (before.value || 0) : 0;
            const nowVal = after.value || 0;

            const isCompletedEvent = !wasCompleted && isNowCompleted;
            const isProgressEvent = !isNowCompleted && nowVal > prevVal;

            if (!isCompletedEvent && !isProgressEvent) {
                return null;
            }

            const [roomSnap, habitSnap] = await Promise.all([
                db.collection('rooms').doc(roomId).get(),
                db.collection('rooms').doc(roomId).collection('habits').doc(habitId).get(),
            ]);

            if (!roomSnap.exists) return null;
            const roomData = roomSnap.data();
            const roomName = roomData.name || 'Sosyal Oda';
            const memberIds = roomData.memberIds || [];

            const habitData = habitSnap.exists ? habitSnap.data() : null;
            const habitTitle = habitData ? (habitData.title || 'Alışkanlık') : 'Alışkanlık';
            const habitUnit = (habitData && habitData.unit) ? ` ${habitData.unit}` : '';
            const habitTarget = habitData ? (habitData.targetCount || 1) : 1;

            const memberName = after.displayName || 'Bir üye';

            let title = '';
            let body = '';

            if (isCompletedEvent) {
                title = `🏆 ${memberName} hedefini tamamladı!`;
                body = `${roomName} odasında "${habitTitle}" görevini bitirdi! Sıralamayı kaptırma, sen de yap! 🔥`;
            } else {
                const diff = nowVal - prevVal;
                title = `⚡ ${memberName} hız kesmiyor!`;
                body = `${roomName} odasında "${habitTitle}" için +${diff}${habitUnit} ilerledi (${nowVal}/${habitTarget}). Rekabete katıl! 🚀`;
            }

            await sendNotificationToUsers({
                uids: memberIds,
                excludeUid: uid,
                title: title,
                body: body,
                data: {
                    type: 'room_progress',
                    roomId: roomId,
                    habitId: habitId,
                    memberUid: uid,
                },
            });
            return null;
        } catch (err) {
            console.error('Error in onRoomHabitProgressWritten:', err);
            return null;
        }
    });

