import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:tchat_app/base/generic_account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/main.dart';
import 'package:tchat_app/models/account_model.dart';
import 'package:tchat_app/screens/friends/suggest_friends_screen.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/custom_row_setting.dart';
import 'package:tchat_app/widget/text_style.dart';
import 'package:tchat_app/widget/widget.dart';
import '../../controller/my_router.dart';
import '../account/my_profile_screen.dart';
import '../account/update_account_screen.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends GenericAccountState<MoreScreen>
    with AutomaticKeepAliveClientMixin {
  var reload;
  @override
  Widget build(BuildContext context) {
    if(ProviderController(context).getUserUpdated()){
      reload =initData();// todo call back when user update info from other screen
    }
    return Container(
      child: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                myAccount == null ? Container() : myProFileUI(),
                SizedBox(
                  height: 20,
                ),
                listOptionUI(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }
  initData() async {
    myAccount = await getAccountFromFloorDB();
    if(mounted){
      setState(() {
        this.myAccount =myAccount;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget myProFileUI() {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: Container(
          margin:
              EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
          child: Row(
            children: [
              Container(
                child: myAccount.photoURL.isEmpty?CircleAvatar(radius: 30.0,backgroundImage:AssetImage(PATH_AVATAR_NOT_AVAILABLE)):Material(
                 child: cachedImage(myAccount.photoURL,45.0,45.0),
                 borderRadius: BorderRadius.all(
                     Radius.circular(45.0)),
                 clipBehavior: Clip.hardEdge,
               ),
                width: 45,
                height: 45,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myAccount.fullName,
                        style: textBlackMedium(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'My Profile',
                        style: textGraysSmall(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        openScreenWithName(MyProfileScreen());
      },
    );
  }

  Widget listOptionUI() {
    return Column(
      children: [
        CustomRowSetting(
          onPressed: () {
            Navigator.pushNamed(context, TAG_UPDATE_ACCOUNT,
                arguments: myAccount);
          },
          title: 'Update Account',
          icon: 'images/icons/ic_edit_blue.png',
        ),
        CustomRowSetting(
          onPressed: () {
            openScreenWithName(SuggestFriendsScreen(myAccount));
          },
          title: 'Suggest Friends',
          icon: 'images/icons/ic_friends_light_blue.png',
        ),
        CustomRowSetting(
          onPressed: () {
            floorDB.messageDao.deleteAllMessage();
            floorDB.lastMessageDao.deleteAllLastMessage();
            // todo handle clear on firebase
            ProviderController(context).setReloadLastMessage(true);
          },
          title: 'Clear Data Chat',
          icon: 'images/icons/ic_remove_red.png',
        ),
        CustomRowSetting(
          onPressed: () {
            checkAccountForLogout();
          },
          title: 'Logout',
          icon: 'images/icons/ic_logout.png',
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
