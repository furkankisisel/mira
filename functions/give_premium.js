const admin = require("firebase-admin");

// 🔴 JSON DOSYA ADINI AYNEN YAZ
const serviceAccount = require("./mira-1fdc3-firebase-adminsdk-fbsvc-c605bd8f60.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const uids = [
  "AlJTUGFu65hdFYEyGF5HFfnvd113",
  "o48qzUlnOwSlsocJGRUtFutQMlh2",
  "bjdzN9nV1ea4nsLfvZqouUpYDRx1",
  "Fz316mrfmGP1tv7W62NBQjOnIYk2",
  "tEQnM58xrwVtTPIgN33ObtWwwrp2",
  "Cu3h27hkMpUX2vlabYm0aAcLWtJ3",
  "IWUfh2BQKHMo23aHc4H9LD1ZWg92",
  "xo55ZOBBocOUpk4euhJFaR0pgTj1",
  "N16dphy554OoRXlaIH5mVHbXsMu1",
  "uffyIKKUwshtXHYOJ0eH8at0r7q1",
  "VdK2GcbifJN9oUQSQctbihhFrDn1",
  "lAXhtVR6wBhPOyrU2TwGjFCtJMm2",
];

uids.forEach(async (uid) => {
  await admin.auth().setCustomUserClaims(uid, { premium: true });
  console.log("Premium verildi:", uid);
});
