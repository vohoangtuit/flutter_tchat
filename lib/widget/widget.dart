import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget materialApp(BuildContext context, String title) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
  );
}

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Image.asset(
      'assets/images/logo.png',
      height: 45,
    ),
  );
}

Widget appBarWithTitleCenter(BuildContext context, String title) {
  return AppBar(
    title: Text(title, style: titleTextWhite()),
    centerTitle: true,
  );
}
Widget appBarWithTitle(BuildContext context, String title) {
  return AppBar(
    title: Text(title, style: titleTextWhite()),
    centerTitle: false,
  );
}

InputDecoration inputDecoration(
    String labelText, String hintText, String errorText) {
  return InputDecoration(
    // labelText: labelText ,
    hintText: hintText,
    // errorText: errorText,
    hintStyle: TextStyle(color: Colors.white54),
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    enabledBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}
TextStyle smallTextWhite() {
  return TextStyle(color: Colors.white, fontSize: 13);
}
TextStyle normalTextWhite() {
  return TextStyle(color: Colors.white, fontSize: 14);
}

TextStyle mediumTextWhite() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle titleTextWhite() {
  return TextStyle(color: Colors.white, fontSize: 18);
}

TextStyle normalTextStyleButton(Color color) {
  return TextStyle(color: color, fontSize: 17);
}
TextStyle textMessage() {
  return TextStyle(color: Colors.white, fontSize: 16);
}
Decoration decorationMessageRight(){
  return BoxDecoration(
   color: Colors.blue,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23),bottomLeft: Radius.circular(23)),
  );
}
Decoration decorationMessageLeft(){
  return BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23),bottomRight: Radius.circular(23)),
  );
}
BoxDecoration decorationButton(Color color, double borderRadius) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(borderRadius),
  );

}
InputDecoration inputDecoratio(String hintText){
  return InputDecoration.collapsed(
    hintText: hintText,
    border: InputBorder.none,
  );
}
Container iconEditInfo(){
  return Container(
      alignment: Alignment.centerRight,
      child: Image.asset('images/icons/ic_pen_gray.png',width: 15,height: 15,)
  );
}