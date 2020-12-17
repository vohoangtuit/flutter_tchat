import 'dart:io';

import 'package:flutter/material.dart';

import 'package:tchat_app/base/base_account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/screens/friends/suggest_friends_screen.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/custom_row_setting.dart';
import 'package:tchat_app/widget/text_style.dart';
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
                  myProFileUI(),
                  SizedBox(height: 20,),
                  listOptionUI(),
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
  Widget myProFileUI(){
    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: Container(
          margin: EdgeInsets.only(left: 10.0,top: 10.0,right: 10.0,bottom: 10.0),
          child: Row(
            children: [
              Container(
                child:  CircleAvatar(
                  radius: 30.0,
                  backgroundImage: userModel.photoURL.isEmpty ? AssetImage(PATH_AVATAR_NOT_AVAILABLE):NetworkImage(userModel.photoURL),
                  backgroundColor: Colors.transparent,
                ),
                width: 45,height: 45,
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

  Widget listOptionUI() {
    return Column(
      children: [
        CustomRowSetting(
          onPressed: () {
            openScreen(UpdateAccountScreen(userModel));
          },
          title: 'Update Account', icon: 'images/icons/ic_edit_blue.png',
        ),
        CustomRowSetting(
          onPressed: () {
            openScreen(SuggestFriendsScreen());
          },
          title: 'Suggest Friends', icon: 'images/icons/ic_friends_light_blue.png',
        ),
        CustomRowSetting(
          onPressed: () {
            messageDao.deleteAllMessage();
            lastMessageDao.deleteAllLastMessage();
            // todo handle clear on firebase
            ProviderController(context).setReloadLastMessage(true);
          },
          title: 'Clear Data Chat', icon: 'images/icons/ic_remove_red.png',
        ),
        CustomRowSetting(
          onPressed: () {
            checkAccountForLogout();
          },
          title: 'Logout', icon: 'images/icons/ic_logout.png',
        ),

      ],
    );
  }
  @override
  bool get wantKeepAlive => true;

}
