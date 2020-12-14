import 'package:flutter/cupertino.dart';
import 'package:tchat_app/models/user_model.dart';

class AccountBloc with ChangeNotifier {
  UserModel user ;

  bool userUpdated =false;

  getAccount() => user;

  getUserUpdated()=>userUpdated;

  setAccount(UserModel userModel){
    this.user =userModel;
    notifyListeners();
  }
  setUserUpdated(bool update){
    print('AccountBloc user changed');
    this.userUpdated =update;
  }
}