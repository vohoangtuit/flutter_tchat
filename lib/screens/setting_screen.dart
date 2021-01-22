
import 'package:flutter/material.dart';
import 'package:tchat_app/base/generic_account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/widget/basewidget.dart';
import 'package:tchat_app/widget/custom_row_setting.dart';

import '../main.dart';
import '../controller/my_router.dart';
import 'account/update_account_screen.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends GenericAccountState<SettingScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWithTitle(context,'Settings'),
      body: Container(
        child: initUI(),
      ),
    );
  }
Widget initUI(){
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomRowSetting(
            onPressed: (){
             // openScreenWithName(UpdateAccountScreen(myAccount));
              Navigator.pushNamed(context, TAG_UPDATE_ACCOUNT,arguments: account);
            },
            title: 'Update Account', icon: 'images/icons/ic_edit_blue.png',
          ),
          CustomRowSetting(
            onPressed: (){
              floorDB.messageDao.deleteAllMessage();
              floorDB.lastMessageDao.deleteAllLastMessage();
              // todo handle clear on firebase
              ProviderController(context).setReloadLastMessage(true);
            },
            title: 'Clear Data Chat', icon: 'images/icons/ic_remove_red.png',
          ),
          CustomRowSetting(
            onPressed: (){
              checkAccountForLogout();
            },
            title: 'Logout', icon: 'images/icons/ic_logout.png',
          ),

        ],
      ),
    );
  }
}
