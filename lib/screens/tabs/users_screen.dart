import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/items/item_users.dart';

import 'package:tchat_app/base/base_account_statefulwidget.dart';


class UsersScreen extends StatefulWidget {
  @override
  State createState() => UsersScreenState();
}

class UsersScreenState extends AccountBaseState<UsersScreen>  {//with AutomaticKeepAliveClientMixin
  bool isLoading = false;
  List<UserModel> listUser = List();
  Stream streamUsers;
  Stream user;
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
    //DocumentSnapshot variable = await firebaseDataService.checkUserIsFriend(userModel.id, user.id);

    if(userModel==null){
      userModel = await getAccount();

    }

    if(userModel!=null){
      Stream<QuerySnapshot> stream = FirebaseFirestore.instance.collection(FIREBASE_FRIENDS).snapshots();
     // jsonObject = Customers(error: false, errorCode: 0, Items: List<Customers_items>());
      stream.forEach((QuerySnapshot element) {
        if (element == null){
          print('null');
        } else{
          print('not null');
          print(json.decode(stream.toString()).toString());
          print(element.size.toString());
          String data =element.toString();
        }

        // setState(() {
        //   jsonObject.Items = element.documents.map((e) => Customers_items.fromJson(e.data)).toList();
        // });
      });


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
                    context, snapshot.data.documents[index], userModel,false),
              )
            : Container();
      },
    );
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
