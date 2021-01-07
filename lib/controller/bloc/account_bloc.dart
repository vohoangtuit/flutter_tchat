import 'package:flutter/cupertino.dart';
import 'package:tchat_app/models/user_model.dart';

class AccountBloc with ChangeNotifier {
  UserModel myProfile ;
  UserModel userOtherProfile ;

  bool userUpdated =false;

  getMyAccount() => myProfile;
  getOtherAccount() => userOtherProfile;

  getUserUpdated()=>userUpdated;

  setMyAccount(UserModel userModel){
    this.myProfile =userModel;
    print('my accou notifyListeners');
    notifyListeners();
  }
  setOtherAccount(UserModel userModel){
    this.userOtherProfile =userModel;
    notifyListeners();
  }
  setUserUpdated(bool update){
    this.userUpdated =update;
  }
}