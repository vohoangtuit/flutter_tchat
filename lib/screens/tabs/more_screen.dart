import 'package:flutter/material.dart';

import 'package:tchat_app/base/account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/widget/button.dart';
import 'package:tchat_app/widget/view_header_main_screen.dart';
import '../setting_screen.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends AccountBaseState<MoreScreen> with AutomaticKeepAliveClientMixin{

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    if(userModel==null){
      return Container();
    }else{
     // print("_MoreScreenState ${userModel.fullName}");
      return Container(
        child: Column(
          children: [
            headerMessage(),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(

                  children: [
                    SizedBox(height: 20,),
                    Text('FullName: ${userModel.fullName}'),
                    SizedBox(height: 10,),
                    Text('id: ${userModel.id}'),
                    NormalButton(title: 'Setting',onPressed: (){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ChatSettings()));
                    },),
                    SizedBox(height: 10,),
                    NormalButton(title: 'LogOut',onPressed: (){
                      checkAccountForLogout();
                    },),
                    SizedBox(height: 10,),
                    NormalButton(title: 'Clear Data Chat',onPressed: (){
                     messageDao.deleteAllMessage();
                     lastMessageDao.deleteAllLastMessage();
                   // todo handle clear on firebase
                     ProviderController(context).setReloadLastMessage(true);
                    },),
                  ],
                ),
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
  checkAccountForLogout()async{
    await SharedPre.getIntKey(SharedPre.sharedPreAccountType).then((value) {
      if(value!=null){
        if(value==USER_ACCOUNT_FACEBOOK){
          logOutFacebook();
        }
        else if(value==USER_ACCOUNT_GMAIL){
          logoutGoogle();
        }else{
          print('please check again account type');
        }
      }
    });
  }
  Future<Null> logoutGoogle() async {
    this.setState(() {
      isLoading = true;
    });

    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
    await SharedPre.clearData();

    this.setState(() {
      isLoading = false;
      userModel =null;
    });

    openMyAppAndRemoveAll();
  }
  Future<void> logOutFacebook() async {
    setState(() {
      isLoading = true;
    });
    await facebookLogin.logOut();
    setState(() {
      isLoading = false;
    });
    await SharedPre.clearData();
    openMyAppAndRemoveAll();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive =>true;


}
