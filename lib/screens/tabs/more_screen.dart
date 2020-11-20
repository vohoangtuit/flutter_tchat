import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/widget/button.dart';

import '../main.dart';
import '../settings.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with AutomaticKeepAliveClientMixin<MoreScreen>{
  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            NormalButton(title: 'Setting',onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ChatSettings()));
            },),
            SizedBox(height: 10,),
            NormalButton(title: 'LogOut',onPressed: (){
              handleSignOut();
            },),
          ],
        ),
      ),
    );
  }
  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await SharedPre.clearData();

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
            (Route<dynamic> route) => false);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
