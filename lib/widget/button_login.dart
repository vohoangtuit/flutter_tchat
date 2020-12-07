import 'package:flutter/material.dart';
import 'package:tchat_app/widget/text_style.dart';

class ButtonLogin extends StatelessWidget {
  final VoidCallback onPressed;

  final String icon;
  final String title;

  ButtonLogin({@required this.onPressed,@required this.icon,@required this.title});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      height: 45,
      child: RaisedButton(
        onPressed: onPressed,
        color: Colors.lightBlueAccent,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0)),
        child: Container(
          width: 200,
          child: Row(
            children: [
              Image.asset(icon,width: 26,height: 26,),
              SizedBox(width: 15,),
              Text(
                title,
                style: textWhiteButtonDefault(),
              ),
            ],
          ),
        ),
        
      ),
    );
  }
}