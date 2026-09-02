// Firebase Cloud Function — deploy this to your Firebase project.
// It triggers when a new SOS alert is written to Firestore,
// then sends FCM push notifications to the user's emergency contacts.
// No FCM server key needed in the Flutter app at all.
//
// Deploy: firebase deploy --only functions
//
// Setup:
//   cd functions
//   npm install firebase-admin firebase-functions
//   (paste this file as functions/index.js)








// const functions = require('firebase-functions');
// const admin     = require('firebase-admin');
// admin.initializeApp();

// const db        = admin.firestore();
// const messaging = admin.messaging();

// exports.sendSosNotification = functions.firestore
//   .document('sos_alerts/{alertId}')
//   .onCreate(async (snap, context) => {
//     const alertId = context.params.alertId;
//     const data    = snap.data();

//     const userId       = data.userId;
//     const travelerName = data.travelerName || 'Traveler';
//     const locationUrl  = data.locationUrl  || '';
//     const sosTime      = data.sosTime      || new Date().toISOString();
//     const bookingTitle = data.bookingTitle || 'No active booking';
//     const caretaker    = data.caretakerName || 'N/A';

//     // Fetch user doc to get emergency contact FCM tokens
//     const userSnap = await db.collection('users').doc(userId).get();
//     if (!userSnap.exists) {
//       console.log(`User ${userId} not found`);
//       return null;
//     }

//     const userData = userSnap.data();
//     const contacts = userData.emergencyContacts || [];   // array of maps
//     const govToken = userData.govEmergencyFcmToken || null;

//     // Collect all FCM tokens
//     const tokens = contacts
//       .map(c => c.fcmToken)
//       .filter(t => t && t.length > 0);

//     if (govToken) tokens.push(govToken);

//     if (tokens.length === 0) {
//       console.log('No FCM tokens found for user', userId);
//       return null;
//     }

//     const notificationBody =
//       `📍 ${locationUrl}\n` +
//       `🕐 ${sosTime}\n` +
//       `Booking: ${bookingTitle} | Caretaker: ${caretaker}`;

//     const message = {
//       notification: {
//         title: `🆘 SOS ALERT — ${travelerName}`,
//         body:  notificationBody,
//       },
//       data: {
//         type:      'SOS_ALERT',
//         alertId:   alertId,
//         userId:    userId,
//         mapsUrl:   locationUrl,
//         sosTime:   sosTime,
//       },
//       android: {
//         priority: 'high',
//         notification: { channelId: 'sos_channel', sound: 'default' },
//       },
//       apns: {
//         headers: { 'apns-priority': '10' },
//         payload: { aps: { sound: 'default' } },
//       },
//       tokens: tokens,
//     };

//     try {
//       const response = await messaging.sendEachForMulticast(message);
//       console.log(`SOS alert ${alertId}: ${response.successCount}/${tokens.length} notifications sent`);
//     } catch (err) {
//       console.error('FCM send error:', err);
//     }

//     return null;
//   });






























const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { getMessaging } = require("firebase-admin/messaging");

initializeApp();

const db        = getFirestore();
const messaging = getMessaging();

exports.sendSosNotification = onDocumentCreated(
  "sos_alerts/{alertId}",
  async (event) => {
    const alertId = event.params.alertId;
    const data    = event.data.data();

    const userId       = data.userId       || "unknown";
    const travelerName = data.travelerName || "Traveler";
    const locationUrl  = data.locationUrl  || "";
    const sosTime      = data.sosTime      || new Date().toISOString();
    const bookingTitle = data.bookingTitle || "No active booking";
    const caretaker    = data.caretakerName || "N/A";

    // Fetch user doc to get emergency contact FCM tokens
    const userSnap = await db.collection("users").doc(userId).get();
    if (!userSnap.exists) {
      console.log(`User ${userId} not found`);
      return null;
    }

    const userData = userSnap.data();
    const contacts = userData.emergencyContacts || [];
    const govToken = userData.govEmergencyFcmToken || null;

    // Collect FCM tokens
    const tokens = contacts
      .map((c) => c.fcmToken)
      .filter((t) => t && t.length > 0);

    if (govToken) tokens.push(govToken);

    if (tokens.length === 0) {
      console.log("No FCM tokens found for user", userId);
      return null;
    }

    const notificationBody =
      `📍 ${locationUrl}\n` +
      `🕐 ${sosTime}\n` +
      `Booking: ${bookingTitle} | Caretaker: ${caretaker}`;

    const message = {
      notification: {
        title: `🆘 SOS ALERT — ${travelerName}`,
        body:  notificationBody,
      },
      data: {
        type:    "SOS_ALERT",
        alertId: alertId,
        userId:  userId,
        mapsUrl: locationUrl,
        sosTime: sosTime,
      },
      android: {
        priority: "high",
        notification: { channelId: "sos_channel", sound: "default" },
      },
      apns: {
        headers: { "apns-priority": "10" },
        payload: { aps: { sound: "default" } },
      },
      tokens: tokens,
    };

    try {
      const response = await messaging.sendEachForMulticast(message);
      console.log(
        `SOS alert ${alertId}: ${response.successCount}/${tokens.length} notifications sent`
      );
    } catch (err) {
      console.error("FCM send error:", err);
    }

    return null;
  }
);