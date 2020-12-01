import 'package:flutter/cupertino.dart';
import 'package:tchat_app/widget/loading.dart';

class ReloadMessage with ChangeNotifier{
  bool reloadMessage=false;

  getReload() => reloadMessage;

  void setReload(bool reload){
    this.reloadMessage = reload;
    notifyListeners();
  }
}