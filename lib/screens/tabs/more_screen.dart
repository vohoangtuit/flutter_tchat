import 'dart:io';

import 'package:flutter/material.dart';

import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/widget/button.dart';
import 'package:tchat_app/widget/text_style.dart';
import 'package:tchat_app/widget/toolbar_main.dart';
import '../account/my_profile_screen.dart';
import '../account/update_account_screen.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends AccountBaseState<MoreScreen> with AutomaticKeepAliveClientMixin{

  var reload;
  @override
  Widget build(BuildContext context) {
   if(ProviderController(context).getUserUpdated()){
     reload =getAccount();// todo call back when user update info from other screen
   }
    if(userModel==null){
      return Container();
    }else{
      return Container(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  myProfile(),
                  SizedBox(height: 20,),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }
  Widget myProfile(){
    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0,bottom: 10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: userModel.photoURL.isEmpty ? AssetImage('images/img_not_available.jpeg'):NetworkImage(userModel.photoURL),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(width: 20,),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userModel.fullName,style: mediumTextBlack(), overflow: TextOverflow.ellipsis, maxLines: 1,),
                      SizedBox(height: 5,),
                      Text('My Profile',style: smallTextGray(),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        openScreen(MyProfileScreen());
      },
    );
  }


  @override
  bool get wantKeepAlive => true;

}
