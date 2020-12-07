import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget headerMessage(){
  return Container(
    color: Colors.lightBlue,
    height: 50,
    child: Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15.0,top: 0.0,right: 10.0,bottom: 0.0),
            child: Image.asset('images/icons/ic_search.png',width: 24,height: 24,),
          ),
      ],
    ),
  );
}