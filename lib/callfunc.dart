Future<void> makeCall(BuildContext context, String receiverName,
    String receiverUid, String receiverProfilePic, bool isGroupChat) async {
  // Generate a unique call ID using Uuid
  String callId = const Uuid().v1();
  // Prepare call data for both the sender and receiver
  Call senderCallData = Call(
    callerId: SessionController().userId.toString(),
    callerName: SessionController().name.toString(),
    callerPic: SessionController().profilePic.toString(),
    receiverId: receiverUid,
    receiverName: receiverName,
    receiverPic: receiverProfilePic,
    callId: callId,
    hasDialled: true,
  );

  Call receiverCallData = Call(
    callerId: SessionController().userId.toString(),
    callerName: SessionController().name.toString(),
    callerPic: SessionController().profilePic.toString(),
    receiverId: receiverUid,
    receiverName: receiverName,
    receiverPic: receiverProfilePic,
    callId: callId,
    hasDialled: false,
  );
  // Call the function to handle the call and navigate to the call screen
  await callUser(senderCallData, context, receiverCallData);
}
// Function to handle the call and navigate to the call screen
Future callUser(
    Call senderCallData,
    BuildContext context,
    Call receiverCallData,
    ) async {
  try {
    // Store call data in Firestore
    await FirebaseFirestore.instance
        .collection('call')
        .doc(senderCallData.callerId)
        .set(senderCallData.toMap());
    await FirebaseFirestore.instance
        .collection('call')
        .doc(senderCallData.receiverId)
        .set(receiverCallData.toMap());
    // Navigate to the call screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallScreen(
          channelId: senderCallData.callId,
          call: senderCallData,
          isGroupChat: false,
        ),
      ),
    );
  } catch (e) {
    // Handle any errors
    Utils.toasstMessage(e.toString());
  }
}