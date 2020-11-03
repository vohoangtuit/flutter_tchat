import 'package:flutter/material.dart';
import 'package:tchat_app/widget/progressbar.dart';

import 'dialog.dart';
typedef Int2VoidFunc = void Function(String);
abstract class BaseStatefulState<T extends StatefulWidget> extends State<T> {
  BaseDialog  dialog;
 static BaseStatefulState baseStatefulState;
  var  restApi;
  ProgressBar progressBar;
  bool onStart =false;
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Container(

        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    progressBar= new ProgressBar();
    baseStatefulState=this;
    //restApi =  RestClient(baseStatefulState:baseStatefulState);
  }
  @override
  void dispose() {
    progressBar.hide();
    super.dispose();
  }
  void showLoading() {
    progressBar.show(context);
  }

  void hideLoading() {
    progressBar.hide();
  }

  void baseMethod() {
    // Parent method
  }
  showBaseDialog(String title,String description){
    if(dialog!=null){
      dialog.dismiss();
    }
    dialog = new BaseDialog(title: title, description: description);
    showDialog(
     // barrierDismissible: false,// touch outside dismiss
      context: context,
      builder: (BuildContext context) => dialog
    );
  }

}


