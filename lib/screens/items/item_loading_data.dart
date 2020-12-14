
import 'package:flutter/material.dart';
import 'package:tchat_app/utils/const.dart';

Widget buildItemLoadingData(BuildContext context) {
  return Container(
    child: FlatButton(
      padding: EdgeInsets.only(left: 10.0,top: 0.0,right: 5.0,bottom: 0.0),
      onPressed: () {  },
      child: Padding(
        padding: EdgeInsets.only(left: 0.0,top: 8.0,right: 0.0,bottom: 10.0),
        child: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[200],
                ),
                Container(
                  padding: EdgeInsets.only(left: 8.0,top: 0.0,right: 40.0,bottom: 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5,),
                      Container(color: Colors.grey[200],width: 100,height: 7,),
                      SizedBox(height: 15,),
                      Container(color: Colors.grey[200],width: 40,height: 7,),
                    ],

                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Container(color: Colors.grey[200],width: 70,height: 7),
            )
          ],
        ),
      ),

    ),
  );
}