import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/firebase_services/firebase_database.dart';
import 'package:tchat_app/models/friends_model.dart';
import 'package:tchat_app/screens/items/item_friend_requet.dart';

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
      itemBuilder: (context,index)=>ItemFriendRequest(context, listFriend[index], userModel),
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
    await FirebaseFirestore.instance.collection(FIREBASE_FRIENDS).doc(userModel.id).collection(userModel.id).where(FRIEND_STATUS_REQUEST,isEqualTo: FRIEND_WAITING_CONFIRM).get().then((value) {
      if(value.size>0){
        List<FriendModel> data =List();
        for(int i=0;i<value.size;i++ ){
          QueryDocumentSnapshot doc =value.docs[i];
          data.add(FriendModel.fromQuerySnapshot(doc));

        }
        setState(() {
          listFriend =data;
          print(' friends '+listFriend.length.toString());
        });
      }else{
        print('no data ');
      }
      setState(() {
        isLoading =false;
      });
    });
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
