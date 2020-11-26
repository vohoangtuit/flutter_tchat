import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/progressbar.dart';

import 'dialog.dart';
typedef Int2VoidFunc = void Function(String);
abstract class BaseStatefulState<T extends StatefulWidget> extends State<T> {
  BaseDialog  dialog;
 static BaseStatefulState baseStatefulState;
  var  restApi;
  ProgressBar progressBar;
  bool onStart =false;
  FirebaseFirestore fireBaseStore;
  FirebaseFirestore userRef;
  FirebaseFirestore msgRef;

  String idMe='';
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Container(

        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    if(!onStart){
      baseStatefulState=this;
      fireBaseStore = FirebaseFirestore.instance;
     // userRef = fireBaseStore.collection(FIREBASE_USERS) as FirebaseFirestore;
     // msgRef = fireBaseStore.collection(FIREBASE_MESSAGES) as FirebaseFirestore;
      progressBar = ProgressBar();
      onStart =true;
    }
    if(idMe.isEmpty){
      _getProfile();
    }
  }
  void _getProfile() async{
    await SharedPre.getStringKey(SharedPre.sharedPreID).then((value)  {
      setState(() {
        idMe =value;
      });
    });
  }
  @override
  void dispose() {
    progressBar.hide();
    super.dispose();
  }
  void showLoading() {
    progressBar.show(context);
  }

  void hideLoading() {
    progressBar.hide();
  }

  void baseMethod() {
    // Parent method
  }
  showBaseDialog(String title,String description){
    if(dialog!=null){
      dialog.dismiss();
    }
    dialog = new BaseDialog(title: title, description: description);
    showDialog(
     // barrierDismissible: false,// touch outside dismiss
      context: context,
      builder: (BuildContext context) => dialog
    );
  }

}


