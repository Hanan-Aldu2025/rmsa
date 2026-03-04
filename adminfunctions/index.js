const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotification = functions.https.onRequest(async (req, res) => {
  const { title, body } = req.body;

  const message = {
    notification: {
      title: title,
      body: body,
    },
    topic: "all_users",
  };

  await admin.messaging().send(message);

  res.status(200).send({
    success: true,
    message: "Notification sent successfully",
  });
});