import 'package:flutter/cupertino.dart';
import 'package:tchat_app/models/user_model.dart';

class AccountBloc with ChangeNotifier {
  UserModel user ;

  getAccount() => user;

  setAccount(UserModel userModel){
    this.user =userModel;
    print('user notify change');
    notifyListeners();
  }

}