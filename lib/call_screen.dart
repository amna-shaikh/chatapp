import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "a28be509a7404ebc9f42459393ba1cfa",
      channelName: "test",
      username: "user",
    ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Agora VideoUIKit'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              layoutType: Layout.floating,
              enableHostControls: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              client: client,
              addScreenSharing: false,
              enabledButtons : [
                BuiltInButtons.toggleCamera,
                BuiltInButtons.toggleMic,
                BuiltInButtons.switchCamera,
                BuiltInButtons.callEnd

              ],

              // Add this to enable screen sharing
            ),
          ],
        ),
      ),
    );

  }
}
