import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/screens/items/item_my_request_friend.dart';

class MyRequestScreen extends StatefulWidget {
  @override
  _MyRequestScreenState createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends AccountBaseState<MyRequestScreen>
    with AutomaticKeepAliveClientMixin {
  List<FriendModel> listFriend = List();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: initListView(),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget initListView() {
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      padding: EdgeInsets.all(0.0),
      itemCount: listFriend.length,
      itemBuilder: (context, index) => ItemMyFriendRequest(
          context, listFriend[index], userModel,languageCode, (friend) {
            handleActionCick(friend);
      }),
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300], height: 0.5,
        //indent: 10.0,// padding left
        //endIndent: 20,// padding right
      ),
    );
  }

  getData() async {
    if (userModel == null) {
      userModel = await getAccount();
    }
    setState(() {
      isLoading = true;
    });
    await firebaseDataService
        .getFriendsWithType(userModel.id, FRIEND_SEND_REQUEST)
        .then((value) {
      if (value.size > 0) {
        List<FriendModel> data = List();
        for (int i = 0; i < value.size; i++) {
          QueryDocumentSnapshot doc = value.docs[i];
          Map<String, dynamic> json = doc.data();
          data.add(FriendModel.fromJson(json));
          // data.add(FriendModel.fromQuerySnapshot(doc));todo: get from QueryDocumentSnapshot  cannot check field exits
        }
        setState(() {
          if (listFriend.length > 0) {
            listFriend.clear();
          }
          listFriend = data;
          isLoading = false;
          //  print(' friends l: '+listFriend.length.toString());
        });
      } else {
        print('no data ');
        setState(() {
          if (listFriend.length > 0) {
            listFriend.clear();
          }
          isLoading = false;
        });
      }
    }).catchError((onError) {
      print('onError  ' + onError.toString());
      setState(() {
        isLoading = false;
      });
    });
  }

  handleActionCick(FriendModel friend) async {
    if (friend.actionConfirm != null) {
      if (friend.actionConfirm == FRIEND_ACCTION_CLICK_DENNY) {
        await firebaseDataService
            .acceptFriend(userModel.id, friend.id)
            .then((value) {
          setState(() {
            isLoading = false;
            getData();
            ProviderController(context).setReloadContacts(true);
          });
        });
      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
