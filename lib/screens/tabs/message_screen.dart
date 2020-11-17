import 'package:flutter/material.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> with AutomaticKeepAliveClientMixin<MessageScreen>{
  String id="";
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUID();
  }
  getUID()async{
    id = await SharedPre.getStringKey(SharedPre.sharedPreID);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
