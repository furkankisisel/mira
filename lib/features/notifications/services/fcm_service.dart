import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';

/// Top-level background message handler required by `firebase_messaging`.
/// Must be annotated with `@pragma('vm:entry-point')`.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If the message has a 'notification' payload, Android automatically displays it
  // on the system tray using the channel specified (social_interactions_v2).
  if (kDebugMode) {
    print('🔔 FCM Background Message received: ${message.messageId}');
  }
}

class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  StreamSubscription<User?>? _authSub;
  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<RemoteMessage>? _foregroundMsgSub;
  StreamSubscription<RemoteMessage>? _msgOpenSub;

  String? _lastToken;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      // 1. Request notification permissions
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        print('🔔 FCM AuthorizationStatus: ${settings.authorizationStatus}');
      }

      // 2. Set background handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // 3. Handle foreground notifications
      // When app is in foreground, FCM does not show a system notification by default.
      // We manually forward it to NotificationService so the user sees our branded card!
      _foregroundMsgSub = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('🔔 FCM Foreground Message: ${message.data}');
        }
        final notification = message.notification;
        final title = notification?.title ?? message.data['title'] ?? 'Mira Sosyal Oda';
        final body = notification?.body ?? message.data['body'] ?? '';
        final roomId = message.data['roomId'] as String?;

        final notifId = message.messageId.hashCode.abs() % 2147483647;
        NotificationService.instance.showSocialNotification(
          id: notifId,
          title: title,
          body: body,
          payload: roomId != null ? 'room:$roomId' : null,
          subText: 'Mira • Sosyal Bildirim',
        );
      });

      // 4. Handle notification clicks that opened the app
      _msgOpenSub = FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('🔔 User tapped on FCM notification: ${message.data}');
        }
        // Room navigation can be handled if payload contains roomId
      });

      // 5. Auth listener for token management
      _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
        if (user != null) {
          await syncToken();
        } else {
          _lastToken = null;
        }
      });

      // 6. Token refresh listener
      _tokenRefreshSub = _messaging.onTokenRefresh.listen((newToken) async {
        if (kDebugMode) {
          print('🔔 FCM Token refreshed: $newToken');
        }
        _lastToken = newToken;
        await _saveTokenToFirestore(newToken);
      });

      // Sync token right away if user is already signed in
      if (FirebaseAuth.instance.currentUser != null) {
        await syncToken();
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error initializing FcmService: $e');
      }
    }
  }

  /// Manually sync current FCM token with Firestore
  Future<void> syncToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final token = await _messaging.getToken();
      if (token != null && token.isNotEmpty) {
        _lastToken = token;
        await _saveTokenToFirestore(token);
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error fetching FCM token: $e');
      }
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final userRef = _db.collection('users').doc(uid);
      await userRef.set({
        'fcmTokens': FieldValue.arrayUnion([token]),
        'lastFcmUpdate': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (kDebugMode) {
        print('✅ FCM token synced to Firestore for user $uid');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Error saving FCM token to Firestore: $e');
      }
    }
  }

  Future<void> removeTokenOnLogout() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final token = _lastToken;
    if (uid != null && token != null) {
      try {
        final userRef = _db.collection('users').doc(uid);
        await userRef.update({
          'fcmTokens': FieldValue.arrayRemove([token]),
        });
      } catch (_) {}
    }
    _lastToken = null;
  }

  void dispose() {
    _authSub?.cancel();
    _tokenRefreshSub?.cancel();
    _foregroundMsgSub?.cancel();
    _msgOpenSub?.cancel();
  }
}
