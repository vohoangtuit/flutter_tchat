import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/items/item_users.dart';

import 'package:tchat_app/base/base_account_statefulwidget.dart';

class UsersScreen extends StatefulWidget {
  @override
  State createState() => UsersScreenState();
}

class UsersScreenState extends AccountBaseState<UsersScreen> {
  //with AutomaticKeepAliveClientMixin
  bool isLoading = false;
  List<UserModel> listUser = List();
  Stream streamUsers;

  List<FriendModel> friends =List();
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: userList(),
          ),
        ],
      ),
    );
  }

  getData() async {
    firebaseDataService.getAllUser().then((data) {
      setState(() {
        streamUsers = data;
      });
      hideLoading();
    });
    if (userModel == null) {
      userModel = await getAccount();
    }

    if (userModel != null) {
     setState(() {
       isLoading =true;
     });
   await FirebaseFirestore.instance.collection(FIREBASE_FRIENDS).doc(userModel.id).collection(userModel.id).where(FRIEND_STATUS_REQUEST,isEqualTo: FRIEND_SUCEESS).get().then((value) {
       if(value.size>0){
         List<FriendModel> data =List();
             for(int i=0;i<value.size;i++ ){
               QueryDocumentSnapshot doc =value.docs[i];
               data.add(FriendModel.fromQuerySnapshot(doc));
             }
         setState(() {
           friends =data;
           print(' friends '+friends.length.toString());
         });
       }else{
         print('no data ');
       }
       setState(() {
         isLoading =false;
       });
     });

     // todo improve code
     // await firebaseDataService.getAllFriends(userModel.id).then((value) {
     //   if(value.size>0){
     //     List<FriendModel> data =List();
     //     for(int i=0;i<value.size;i++ ){
     //       QueryDocumentSnapshot doc =value.docs[i];
     //       data.add(FriendModel.fromQuerySnapshot(doc));
     //     }
     //     setState(() {
     //       friends =data;
     //       isLoading =false;
     //       print(' friends '+friends.length.toString());
     //     });
     //   }else{
     //     print('no data ');
     //     setState(() {
     //       isLoading =false;
     //     });
     //   }
     //  }).catchError((onError){
     //   print('onError  '+onError.toString());
     //   setState(() {
     //     isLoading =false;
     //   });
     // });
    }
  }

  Widget userList() {
    return StreamBuilder(
      stream: streamUsers,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(4.0),
                itemCount: snapshot.data.documents.length,
                // snapshot.data.documents.length
                itemBuilder: (context, index) => ItemUser(
                    context, snapshot.data.documents[index], userModel, false),
              )
            : Container();
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
