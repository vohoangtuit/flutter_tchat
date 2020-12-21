import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:tchat_app/controller/providers/providers.dart';

import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/screens/friends/friends_request_screen.dart';
import 'package:tchat_app/screens/items/item_contacts.dart';

import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/widget/list_loading_data.dart';

class ContactsScreen extends StatefulWidget {
  @override
  State createState() => _ContactsScreenState();
}

class _ContactsScreenState extends AccountBaseState<ContactsScreen> with AutomaticKeepAliveClientMixin {//
  List<FriendModel> friends =List();
  var load;
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    if(ProviderController(context).getReloadContacts()){
      load =reloadData();
    }
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

                    openScreen(FriendsRequestScreen());

                  },
                  child: Row(
                    children: [
                    Image.asset('images/icons/ic_user_unknown.png',width: 40,height: 40,),
                    SizedBox(width: 10,),
                    Text('Friend request'),
                  ],)

              ),
            ),
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
                      Image.asset('images/icons/ic_add_user_green.png',width: 40,height: 40,),
                      SizedBox(width: 10,),
                      Text('Add friend'),
                    ],)

              ),
            ),
            Container(height: 3.0,color: Colors.grey[200]),
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
  reloadData() {
   // print('getReloadContacts '+ProviderController(context).getReloadContacts().toString());
    if(ProviderController(context).getReloadContacts()){
      // todo: nếu gọi provider set Data in builder thì sẽ error cảnh báo :setState() or markNeedsBuild() called during build
      // todo dùng Future.delayed Zeo để xử lý
      Future.delayed(Duration.zero, () async {
        getData();
        ProviderController(context).setReloadContacts(false);
      });
    }
  }
  getData() async {
   // print('getData ');
    if (userModel == null) {
      userModel = await getAccount();
    }
    if (userModel != null) {
      setState(() {
        isLoading =true;
      });
      await firebaseDataService.getFriendsWithType(userModel.id,FRIEND_SUCEESS).then((value) {
        if(value.size>0){
          List<FriendModel> data =List();
          for(int i=0;i<value.size;i++ ){
            QueryDocumentSnapshot doc =value.docs[i];
            Map<String, dynamic> json = doc.data();
            data.add(FriendModel.fromJson(json));
           // data.add(FriendModel.fromQuerySnapshot(doc));todo: get from QueryDocumentSnapshot  cannot check field exits
          }
          setState(() {
            isLoading =false;
            if(friends.length>0){
              friends.clear();
            }

            friends =data;
           // print(' friends: '+friends.length.toString());
          });
        }else{

          setState(() {
            isLoading =false;
            if(friends.length>0){
              friends.clear();
            }
          });
         // print(' friends1 '+friends.length.toString());
        }
       }).catchError((onError){
        print('onError  '+onError.toString());
        setState(() {
          isLoading =false;
        });
      });
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
    //  print('rebuild list friends.length '+friends.length.toString());
      return ListView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.all(0.0),
        itemCount: friends.length,
        itemBuilder: (context,index)=>ItemContact(context, friends[index], userModel),
      );
    }

  }


}
