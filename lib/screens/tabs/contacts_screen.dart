import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/items/item_contacts.dart';

import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/widget/list_loading_data.dart';

class ContactsScreen extends StatefulWidget {
  @override
  State createState() => ContactsScreenState();
}

class ContactsScreenState extends AccountBaseState<ContactsScreen> with AutomaticKeepAliveClientMixin{//
  bool isLoading = false;
  List<FriendModel> friends =List();


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0,top: 4.0, right: 4.0,bottom: 4.0),
              child: FlatButton(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 5.0,top:5.0,right: 8.0,bottom: 5.0 ),
                  onPressed: () {
                    print('ontap');

                  },
                  child: Row(
                    children: [
                    Image.asset('images/icons/ic_user_request.png',width: 40,height: 40,),
                    SizedBox(width: 10,),
                    Text('Friend request'),
                  ],)

              ),
            ),
            Container(height: 4.0,color: Colors.grey[300]),
            initListView(),
          ],
      ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    getData();
  }
  getData() async {

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

  Widget initListView() {
    if(friends==null){
      if(isLoading){
        return ListLoadingData();// todo
      }else{
        return Container();
      }

    }else{
      return ListView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.all(0.0),
        itemCount: friends.length,
        itemBuilder: (context,index)=>ItemContact(context, friends[index], userModel),
      );
    }

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
