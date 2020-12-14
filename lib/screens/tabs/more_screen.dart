import 'package:flutter/material.dart';

import 'package:tchat_app/base/account_statefulwidget.dart';
import 'package:tchat_app/controller/providers/providers.dart';
import 'package:tchat_app/models/user_model.dart';
import 'package:tchat_app/shared_preferences/shared_preference.dart';
import 'package:tchat_app/utils/const.dart';
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

  bool isLoading = false;
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

                  NormalButton(title: 'Setting',onPressed: (){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => UpdateAccountScreen(userModel)));
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
              ClipRRect(
                borderRadius: BorderRadius.circular(36.0),
                child: userModel.photoURL.isEmpty?Icon(
                  Icons.account_circle,
                  size: 50.0,
                  color: greyColor2,
                ):Image.network(userModel.photoURL,width: 50,height: 50,fit: BoxFit.cover),
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
  bool get wantKeepAlive => true;

  @override
  void uploadAvatarCover(UserModel user, bool success) {
    print('uploadCallBack MoreScreen');
  }

}
