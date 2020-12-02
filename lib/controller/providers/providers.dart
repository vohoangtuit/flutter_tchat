import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:tchat_app/models/user_model.dart';

import '../bloc/account_bloc.dart';
import '../bloc/reload_messsage_bloc.dart';

class ProviderController{
  BuildContext context;
  ProviderController(BuildContext context){
    this.context = context;
  }
  setReloadLastMessage(bool reload){
    Provider.of<ReloadMessage>(context, listen: false).setReload(reload);
    //Provider.of<ReloadMessage>(context).setReload(reload);
  }
  bool getReloadLastMessage(){
    return  Provider.of<ReloadMessage>(context, listen: false).getReload();
    //return  Provider.of<ReloadMessage>(context).reloadMessage;
  }

  setAccount(UserModel account){
    Provider.of<AccountBloc>(context,listen: false).setAccount(account);
    //Provider.of<AccountBloc>(context).setAccount(account);
  }
  UserModel getAccount(){
    return Provider.of<AccountBloc>(context,listen: false).getAccount();
   // return Provider.of<AccountBloc>(context).user;
  }
}