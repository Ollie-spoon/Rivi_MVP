const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.messageTrigger = functions.firestore.document("Messages/{MessageID}").onCreate(async (snapshot, context) => {
    if(snapshot.empty) {
        console.log("No Devices");
        return;
    }
    var tokens = [
        "eNF5-XaGB7M:APA91bGteCiibPqaOSy0Ongv6jBBfQOG4zl_XnSDF3VEbt0YOxTrbFFtkX6yv3lWyIcOaTeLV0I2qEKPeTvzXHslqjqoHxi0bDETJR-70hEP6NEutsst3wTNTWJKT5rCKIIck_9WPFzu"
    ];
    newData = snapshot.data;
    var payload = {
        notification: {title: "Push title", body: "Push Body", sound: "default"}, 
        data: {click_action: FLUTTER_NOTIFICATION_CLICK, Message_key: "Sample push message"}
    }
    try {
        const response = await admin.messaging().sendToDevice(tokens, payload);
        console.log("Notification successfully sent");
    } catch (error) {
        console.log(error.toString());
    }
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
