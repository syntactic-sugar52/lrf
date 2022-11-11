const functions = require("firebase-functions");
const { user } = require("firebase-functions/v1/auth");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
// exports.onCreateUpvote = functions.firestore.document('/posts/{postId}')

exports.onCreateComment = functions.https.document('/posts/{postId}/comments/{commentItems}').onCreate(async (snapshot, context) => {
    console.log('comment created', snapshot.data);
    // get user connected to post
    const userId = context.params.userId;
    const usersRef = admin.firestore().document(`users/${userId}`);
    await usersRef.get();
    
    // once user data is present, check if notification token is present
  const androidNotificationToken=  document.data.androidNotificationToken;
  if(androidNotificationToken){
    //send notification
    sendNotification(androidNotificationToken, snapshot.data);
  }else{
    console.log('no token for user');
  }
  function sendNotification(androidNotificationToken, commentItems){
    let body;
    body = `${commentItems.name} replied: ${commentItems.text}`
    const message = {
        notification: {body: body},
        token: androidNotificationToken,
        data:{recipient: document.data().userId,}
        
    };
    // send notification
    admin.messaging().sendNotification(message);
    

  }
})