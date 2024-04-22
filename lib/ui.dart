class CallScreen extends StatefulWidget {
  // Existing code for CallScreen
}
class _CallScreenState extends State<CallScreen> {
  AgoraClient? client;
  String? token;
  String baseUrl = 'https://mybackend.herokuapp.com';
  // Function to fetch Agora token from the server
  Future<void> getToken() async {
    final response = await http.get(Uri.parse(
      '$baseUrl/access_token?channelName=video${SessionController().userId}&role=subscriber&uid=0',
    ));
    if (response.statusCode == 200) {
      setState(() {
        token = jsonDecode(response.body)['token'];
      });
      // Initialize Agora
      initAgora();
    }
  }
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000)).then(
          (_) {
        // Fetch Agora token from the server
        getToken();
      },
    );
    // Initialize AgoraClient with connection data
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tempToken: token,
      ),
    );
  }
  // Function to initialize Agora
  void initAgora() async {
    await client!.initialize();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const LoadingWidget()
          : SafeArea(
        child: Stack(
          children: [
            // Agora Video Viewer to display video stream
            AgoraVideoViewer(client: client!),
            // Agora Video Buttons for in-call functionalities
            AgoraVideoButtons(
              client: client!,
              // Disconnect button
              disconnectButtonChild: IconButton(
                onPressed: () async {
                  await client!.engine.leaveChannel();
                  // End the call and navigate back
                  endCall(
                    widget.call.callerId,
                    widget.call.receiverId,
                    context,
                  );
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.call_end),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Function to end the call and perform cleanup
  void endCall(
      String callerId,
      String receiverId,
      BuildContext context,
      ) async {
    try {
      // Remove call data from Firestore
      await FirebaseFirestore.instance
          .collection('call')
          .doc(callerId)
          .delete();
      await FirebaseFirestore.instance
          .collection('call')
          .doc(receiverId)
          .delete();
    } catch (e) {
      // Handle any errors
      Utils.toasstMessage(e.toString());
    }
  }
}