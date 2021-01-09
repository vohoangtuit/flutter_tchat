import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tchat_app/controller/bloc/reload_contacts.dart';

import 'package:tchat_app/models/account_model.dart';

import '../bloc/account_bloc.dart';
import '../bloc/reload_messsage_bloc.dart';

class ProviderController{
  BuildContext context;
  ProviderController(BuildContext context){
    this.context = context;
  }
  setReloadLastMessage(bool reload){
    Provider.of<ReloadMessage>(context, listen: false).setReload(reload);

  }
  bool getReloadLastMessage(){
    return  Provider.of<ReloadMessage>(context, listen: false).getReload();
  }
  setReloadContacts(bool reload){
    Provider.of<ReloadContacts>(context, listen: false).setReload(reload);
  }
  bool getReloadContacts(){
    return  Provider.of<ReloadContacts>(context, listen: false).getReload();

  }
  setMyAccount(AccountModel account){
    Provider.of<AccountBloc>(context,listen: false).setMyAccount(account);
  }
  AccountModel getMyAccount(){
    return Provider.of<AccountBloc>(context,listen: false).getMyAccount();
  }

  setOtherAccount(AccountModel account){
    Provider.of<AccountBloc>(context,listen: false).setOtherAccount(account);
  }
  AccountModel getOtherAccount(){
    return Provider.of<AccountBloc>(context,listen: false).getOtherAccount();
  }

  setUserUpdated(bool update){
    Provider.of<AccountBloc>(context, listen: false).setUserUpdated(update);
  }
  bool getUserUpdated(){
    return  Provider.of<AccountBloc>(context, listen: false).getUserUpdated();
  }
}