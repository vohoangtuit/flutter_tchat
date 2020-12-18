import 'package:flutter/material.dart';
import 'package:tchat_app/base/base_dialog.dart';
import 'package:tchat_app/widget/text_style.dart';

class BaseNotification extends BaseDialog {
  final String title, description;
  BaseNotification({
    @required this.title,
    @required this.description,
  });

  @override
  Widget build(BuildContext context) {
    this.context =context;
    dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: initUI(),
    );
    return dialog;
  }
 Widget initUI(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 20,),
        Text(this.title, style: textBlueMedium(),),
        SizedBox(height: 10,),
        Text(this.description, style: textBlackMedium()),
        SizedBox(height: 10,),
        RaisedButton(
          color: Colors.lightBlue,
          child: Text('OK', style: textWhiteMedium()),
          onPressed: () {
           dismiss();
          },

        ),
        SizedBox(height: 5,),

      ],
    );
 }
}
