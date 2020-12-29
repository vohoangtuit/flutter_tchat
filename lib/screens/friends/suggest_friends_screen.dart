import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/base/generic_account_statefulwidget.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/screens/items/item_users.dart';
import 'package:tchat_app/widget/widget.dart';

class SuggestFriendsScreen extends StatefulWidget {
  @override
  _SuggestFriendsScreenState createState() => _SuggestFriendsScreenState();
}

class _SuggestFriendsScreenState extends GenericAccountState<SuggestFriendsScreen> {
  bool isLoading = false;
  List<UserModel> listUser = List();
  Stream streamUsers;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithTitleCenter(context, 'Suggest Friends'),
      body: Container(
        child: userList(),
      ) ,
    );
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  getData() async {
    firebaseDataService.getAllUser().then((data) {
      setState(() {
        streamUsers = data;
      });
      hideLoading();
    });
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
              context, snapshot.data.documents[index], userModel,true),
        )
            : Container();
      },
    );
  }
}
