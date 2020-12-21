import 'package:flutter/cupertino.dart';

class ReloadContacts with ChangeNotifier{
  bool reloadContacts=false;

  getReload() => reloadContacts;

  void setReload(bool reload){
    this.reloadContacts = reload;
    notifyListeners();
  }
}