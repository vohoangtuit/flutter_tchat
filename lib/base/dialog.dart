import 'package:flutter/material.dart';
import 'package:tchat_app/widget/text_style.dart';

class BaseDialog extends StatelessWidget {
  Dialog dialog;
   final String title, description;
  BaseDialog({
    @required this.title,
    @required this.description,
  });

  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context =context;
      dialog = new Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,

        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 20,),
            Text(this.title, style: textBlueLarge(),),
            SizedBox(height: 10,),
            Text(this.description),
            SizedBox(height: 10,),
            RaisedButton(
              color: Colors.lightBlue,
              child: Text('OK',style: mediumTextWhite()),
              onPressed: (){
                Navigator.pop(context);
              },

            ),
            SizedBox(height: 5,),

          ],
        ),
      );

    return dialog;
  }
  dismiss(){
    if(context!=null){
      Navigator.pop(context);
    }
  }
}
