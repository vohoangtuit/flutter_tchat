import 'package:flutter/cupertino.dart';
import 'package:tchat_app/models/account_model.dart';

class AccountBloc with ChangeNotifier {
  AccountModel myProfile ;
  AccountModel userOtherProfile ;

  bool userUpdated =false;

  getMyAccount() => myProfile;
  getOtherAccount() => userOtherProfile;

  getUserUpdated()=>userUpdated;

  setMyAccount(AccountModel userModel){
    this.myProfile =userModel;
    print('my accou notifyListeners');
    notifyListeners();
  }
  setOtherAccount(AccountModel userModel){
    this.userOtherProfile =userModel;
    notifyListeners();
  }
  setUserUpdated(bool update){
    this.userUpdated =update;
  }
}