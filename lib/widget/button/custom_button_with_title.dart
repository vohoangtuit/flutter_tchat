import 'package:flutter/material.dart';
import 'package:tchat_app/widget/text_style.dart';

class CustomButtonWithTitle extends StatelessWidget {
  final VoidCallback onPressed;

  final String title;
  final Color colorButton;
  final Color colorText;
  final double sizeText;

  CustomButtonWithTitle({@required this.onPressed,@required this.title,this.colorButton,this.colorText,this.sizeText});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 35,
      child: RaisedButton(
        onPressed: onPressed,
        color: colorButton,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(28.0)),
        child: Container(
        //  width: 200,
          child: Padding(
            padding: const EdgeInsets.only(left: 12,right: 12),
            child: Row(
              children: [
                Text(
                  title, style: TextStyle(color: colorText,fontSize: sizeText==null?16:sizeText),),
              ],
            ),
          ),
        ),

      ),
    );
  }
}