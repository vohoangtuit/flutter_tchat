import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/screens/items/item_user_requet_friend.dart';

class UserRequestScreen extends StatefulWidget {
  @override
  _UserRequestScreenState createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends AccountBaseState<UserRequestScreen>with AutomaticKeepAliveClientMixin {
  List<FriendModel> listFriend =List();

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
  Widget initListView(){
    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      padding: EdgeInsets.all(0.0),
      itemCount: listFriend.length,
      itemBuilder: (context,index){
        return ItemUserRequest(context, listFriend[index], userModel,languageCode,(friend){

          handleActionClick(friend);
          },
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300],height: 0.5,
        //indent: 10.0,// padding left
        //endIndent: 20,// padding right
      ),
    );
  }
  getData()async{
    if(userModel==null){
      userModel = await getAccount();
    }
    setState(() {
      isLoading =true;
    });
    await firebaseDataService.getFriendsWithType(userModel.id,FRIEND_WAITING_CONFIRM).then((value) {

      if(value.size>0){
        List<FriendModel> data =List();
        for(int i=0;i<value.size;i++ ){
          QueryDocumentSnapshot doc =value.docs[i];
          Map<String, dynamic> json = doc.data();
          data.add(FriendModel.fromJson(json));
          // data.add(FriendModel.fromQuerySnapshot(doc));todo: get from QueryDocumentSnapshot  cannot check field exits
        }
        setState(() {
          if(listFriend.length>0){
            listFriend.clear();
          }
         // listFriend.addAll(data);
          listFriend=data;
          isLoading =false;
        });
      }else{
        setState(() {
          if(listFriend.length>0){
            listFriend.clear();
          }
          isLoading =false;
        });
      }
    }).catchError((onError){
      setState(() {
        isLoading =false;
      });
    });

  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  handleActionClick(FriendModel friendModel)async{
    print('friendModel '+friendModel.actionConfirm.toString());
    if(friendModel.actionConfirm!=null){
      setState(() {
        isLoading =true;
      });
      if(friendModel.actionConfirm==FRIEND_ACCTION_CLICK_ACCEPT){
       await firebaseDataService.acceptFriend(userModel.id, friendModel.id).then((value){
         setState(() {
           isLoading =false;
           getData();
           ProviderController(context).setReloadContacts(true);
         });
       });
      }else{
        await firebaseDataService.removeFriend(userModel.id, friendModel.id).the((value){
          setState(() {
            isLoading =false;
            getData();
            ProviderController(context).setReloadContacts(true);
          });
        });
      }
    }

  }
}
