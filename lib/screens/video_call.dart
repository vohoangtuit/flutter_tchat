
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/widget/basewidget.dart';
import 'package:tchat_app/widget/basewidget.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class VideoCall extends StatefulWidget {
  final ClientRole role;
  VideoCall({this.role});
  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
 // RtcEngine _engine;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithTitle(context, 'Calling...'),
      body: Center(
        child: Stack(
          children: <Widget>[
            // _viewRows(),
            // _panel(),
            // _toolbar(),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    // _engine.leaveChannel();
    // _engine.destroy();
    super.dispose();
  }
}
