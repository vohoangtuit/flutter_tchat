import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/widget/text_style.dart';

Widget materialApp(BuildContext context, String title) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: title,
  );
}

Widget appBarWithTitle(BuildContext context, String title) {
  return AppBar(
    title: Text(title, style: textWhiteTitle()),
    centerTitle: true,
  );
}

InputDecoration inputDecoration(String hintText,IconData icon) {
  return InputDecoration(
    hintText: hintText,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.teal.shade300, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
    prefixIcon: Icon(
      icon,
      color: Colors.teal,
    ),
    contentPadding: EdgeInsets.only(left: 10, top: 8, right: 10, bottom: 8),// padding
    isDense: true,// padding
  );
}

Decoration decorationMessageRight() {
  return BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(23),
        topRight: Radius.circular(23),
        bottomLeft: Radius.circular(23)),
  );
}

Decoration decorationMessageLeft() {
  return BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(23),
        topRight: Radius.circular(23),
        bottomRight: Radius.circular(23)),
  );
}

BoxDecoration decorationButton(Color color, double borderRadius) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(borderRadius),
  );
}

Widget widgetLogo() {
  return Image.asset(
    'images/logo.png',
    width: 120,
    height: 120,
  );
}

Widget baseGestureDetector(BuildContext context,Widget child){
  return GestureDetector(
    child: child,
    onTap: (){
      FocusScope.of(context).requestFocus(FocusNode());
    },
  );
}

Stack widgetLoading(){

  return Stack(
    children: [
      new Opacity(
        opacity: 0.3,
        child: const ModalBarrier(dismissible: false, color: Colors.grey),
      ),
      new Center(
        child: new CircularProgressIndicator(),
      ),
    ],
  );
}