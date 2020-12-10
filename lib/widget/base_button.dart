import 'package:flutter/material.dart';
import 'package:tchat_app/widget/text_style.dart';

class BaseButton extends StatelessWidget {
  final VoidCallback onPressed;

  final String title;

  BaseButton({@required this.onPressed,@required this.title});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 43,
      child: RaisedButton(
        onPressed: onPressed,
        color: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0)),
        child: Container(
          width: 200,
          child: Center(
            child: Text(
              title,
              style: textWhiteButtonDefault(),
            ),
          ),
        ),

      ),
    );
  }
}