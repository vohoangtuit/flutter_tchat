import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/base/bases_statefulwidget.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends BaseStatefulState<MessageScreen> with AutomaticKeepAliveClientMixin<MessageScreen>{
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    return Container(
     // child: lassMGS(),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();

  }
  Widget lassMGS(){
   return StreamBuilder<DocumentSnapshot>(
        stream: fireBaseStore
            .collection(FIREBASE_MESSAGES)
            .doc(idMe).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            //snapshot -> AsyncSnapshot of DocumentSnapshot
            //snapshot.data -> DocumentSnapshot
            //snapshot.data.data -> Map of fields that you need :)

            print('snapshot '+snapshot.data.data().toString());
          //  print('snapshot '+snapshot.data.c);
      //      print('snapshot '+snapshot.data.data().d);
            print('snapshot 1'+snapshot.toString());
            print('snapshot 2'+snapshot.data.toString());
            print('snapshot 3'+snapshot.data.data().values.toString());
            Map<String, dynamic> documentFields = snapshot.data.data();
            print('documentFields '+documentFields.toString());
            //print('documentFields '+documentFields['content']);
            //TODO Okay, now you can use documentFields (json) as needed
            return Text('sdsd');
          }
        }
    );
  }
  void init()async{
    String id='';
    await SharedPre.getStringKey(SharedPre.sharedPreID).then((value)  {
      id=value;
    });
    final DocumentReference document =   fireBaseStore.collection('messages')
        .doc(id);
    await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
      setState(() {
        data =snapshot.data;
      });
    });
    Map<String,dynamic> map = new Map<String,dynamic>();
    map = json.decode(data);
    print("map -------------------- $map");
    StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance.collection("messages").document(id).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        print("snapshot -------------------- ${json.decode(snapshot.data.toString())}");
       // return _buildList(context, snapshot.data.documents);
      },
    );
  }
  void getListLastMessage() async{
    String id='';
   await SharedPre.getStringKey(SharedPre.sharedPreID).then((value)  {
      id=value;
    });

    print('idMe $id');//8AC6oXq9WAcGm4pZgKjMtqV09d53


    Stream<DocumentSnapshot> provideDocumentFieldStream() {
      return   fireBaseStore.collection('messages')
          .doc(id)
          .snapshots();
    }
    StreamBuilder<DocumentSnapshot>(
        stream: provideDocumentFieldStream(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            //snapshot -> AsyncSnapshot of DocumentSnapshot
            //snapshot.data -> DocumentSnapshot
            //snapshot.data.data -> Map of fields that you need :)

            Map<String, dynamic> documentFields = snapshot.data.data();
            print('documentFields '+documentFields.toString());
            print('documentFields '+documentFields['content']);
            //TODO Okay, now you can use documentFields (json) as needed
            return Text(documentFields['content']);
          }
        }
    );
  }


}
