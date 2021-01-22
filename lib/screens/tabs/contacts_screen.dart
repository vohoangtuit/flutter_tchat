import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';

import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/models/account_model.dart';
import 'package:tchat_app/screens/friends/friends_request_screen.dart';
import 'package:tchat_app/screens/items/item_contacts.dart';

import 'package:tchat_app/base/generic_account_statefulwidget.dart';
import 'package:tchat_app/widget/list_loading_data.dart';

class ContactsScreen extends StatefulWidget {
  @override
  State createState() => _ContactsScreenState();
}

class _ContactsScreenState extends GenericAccountState<ContactsScreen>  {//with AutomaticKeepAliveClientMixin
  List<FriendModel> friends = List();
  var load;
  List<AccountModel> listFriend =List();
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    if (ProviderController(context).getReloadContacts()) {
      load = reloadData();
    }
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 4.0, right: 4.0, bottom: 4.0),
              child: FlatButton(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                      left: 5.0, top: 5.0, right: 8.0, bottom: 5.0),
                  onPressed: () {
                    openScreenWithName(FriendsRequestScreen());
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        'images/icons/ic_user_unknown.png',
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Friend request'),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 4.0, right: 4.0, bottom: 4.0),
              child: FlatButton(
                  color: Colors.white,
                  padding: EdgeInsets.only(
                      left: 5.0, top: 5.0, right: 8.0, bottom: 5.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/icons/ic_add_user_green.png',
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Add friend'),
                    ],
                  )),
            ),
            Container(height: 3.0, color: Colors.grey[200]),
            initListView(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    syncListFriend();
  }
  reloadData() {
    // print('getReloadContacts '+ProviderController(context).getReloadContacts().toString());
    if (ProviderController(context).getReloadContacts()) {
      // todo: nếu gọi provider set Data in builder thì sẽ error cảnh báo :setState() or markNeedsBuild() called during build
      // todo dùng Future.delayed Zeo để xử lý
      Future.delayed(Duration.zero, () async {
        syncListFriend();
        ProviderController(context).setReloadContacts(false);
      });
    }
  }

  Widget initListView() {
    if (listFriend == null) {
      if (isLoading) {
        return ListLoadingData(); // todo
      } else {
        return Container();
      }
    } else {
      //  print('rebuild list friends.length '+friends.length.toString());
      return ListView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.all(0.0),
        itemCount: listFriend.length,
        itemBuilder: (context, index) =>
            ItemContact(context, listFriend[index], account),
      );
    }
  }

  syncListFriend() async{
    if (account == null) {
      account = await getAccountFromSharedPre();
    }
    setState(() {
      isLoading =true;
    });
    List<AccountModel> data =List();
    await FirebaseFirestore.instance
        .collection(FIREBASE_FRIENDS)
        .doc(account.id)
        .collection(account.id)
        .where(FRIEND_STATUS_REQUEST, isEqualTo: FRIEND_SUCEESS)
        .get()
        .then((value) {
          if(value.size > 0){
            if(listFriend.length>0){
              listFriend.clear();
            }
            for(int i=0;i<value.size;i++){
              String idFriend =value.docs[i]['id'];
             // print('id '+idFriend);
              FirebaseFirestore.instance.collection(FIREBASE_USERS).doc(idFriend).get().then((value){
               // print('user '+value.data().toString());
                if(value.data()!=null){
                  Map<String,dynamic> json =value.data();
                 // data.add(UserModel.fromJson(json));
                  setState(() {
                    listFriend.add(AccountModel.fromJson(json));
                    isLoading =false;
                 //   print('listFriend '+listFriend.length.toString());
                  });
                }
               // print('listFriend : '+data.length.toString());

              }).catchError((onError){
                catchError(onError);
              });
            }
          //  print('data '+data.length.toString());

          }else{
            if(this.mounted){
              setState(() {
                if(listFriend.length>0){
                  listFriend.clear();
                  isLoading =false;
                }
              });
            }
          }

    }).catchError((onError){
      catchError(onError);
    });
  }
  void catchError(Object onError){
    print('get friend error: ${onError.toString()}');
    if(this.mounted){
      setState(() {
        isLoading =false;
      });
    }

  }
}
