import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/text_style.dart';

class ToolBarMain extends StatefulWidget {
  int position;
  ValueChanged onClick;
  ToolBarMain({this.position,this.onClick});
  @override
  _ToolBarMainState createState() => _ToolBarMainState();
}

class _ToolBarMainState extends State<ToolBarMain> {
  int search=1;
  int add =2;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      height: 48,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 15.0,top: 0.0,right: 10.0,bottom: 0.0),
            child: GestureDetector(child: Image.asset('images/icons/ic_search.png',width: 22,height: 22,),
              onTap: (){
              },
            ),
          ),
          Expanded(
            child: SizedBox.expand(// todo: using SizedBox.expand to full width
              child: FlatButton(
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Search friends, messages...',style: textHeaderBar(),)),
                onPressed: (){
                  widget.onClick(MAIN_CLICK_SEARCH);
                },
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.only(left: 8.0,top: 0.0,right: 10.0,bottom: 0.0),
            child: Row(
              children: [
                widget.position==0 ?GestureDetector(child: Image.asset('images/icons/ic_plus.png',width: 22,height: 22,),onTap: (){// todo icon tab 1
                  setState(() {
                    widget.onClick(MAIN_CLICK_ADD_TAB_MESSAGE);
                  });

                },):widget.position==1?GestureDetector(child: Image.asset('images/icons/ic_add_user.png',width: 20,height: 20,),onTap: (){// todo icon tab 2
                  setState(() {
                    widget.onClick(MAIN_CLICK_ADD_TAB_CONTACT);
                  });

                },):widget.position==2?GestureDetector(child: Image.asset('images/icons/ic_plus.png',width: 20,height: 20,),onTap: (){// todo icon tab 3
                  setState(() {
                    widget.onClick(MAIN_CLICK_ADD_TAB_GROUP);
                  });

                },):widget.position==3?Row(// todo icon tab 4
                  children: [
                    GestureDetector(child: Image.asset('images/icons/ic_edit.png',width: 20,height: 20,),onTap: (){
                      setState(() {
                        widget.onClick(MAIN_CLICK_EDIT_TAB_TIME_LINE);
                      });
                    },),
                    SizedBox(width: 20,),
                    GestureDetector(child: Image.asset('images/icons/ic_notification.png',width: 20,height: 20,),onTap: (){
                      setState(() {
                        widget.onClick(MAIN_CLICK_NOTIFICATION_TAB_TIME_LINE);
                      });
                    },),
                  ],
                ):GestureDetector(child: Image.asset('images/icons/ic_settings.png',width: 20,height: 20,),onTap: (){// todo icon tab 5
                  setState(() {
                    widget.onClick(MAIN_CLICK_SETTING_TAB_MORE);
                  });

                },),
              ],
            ) ,
          ),
        ],
      ),
    );
  }
}

// Widget headerMain(int position,ValueChanged data){
//   return Container(
//     color: Colors.lightBlue,
//     height: 48,
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //mainAxisAlignment: MainAxisAlignment.spaceAround,spaceBetween
//      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Container(
//           margin: EdgeInsets.only(left: 15.0,top: 0.0,right: 10.0,bottom: 0.0),
//             child: GestureDetector(child: Image.asset('images/icons/ic_search.png',width: 22,height: 22,),
//               onTap: (){
//
//               },
//             ),
//           ),
//         Expanded(
//           child: SizedBox.expand(// todo: using SizedBox.expand to full width
//           child: FlatButton(
//             child: Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text('Search friends, messages...',style: textHeaderBar(),)),
//               onPressed: (){
//                 print('search tap');
//               },
//           ),
//           ),
//         ),
//         Container(
//           alignment: Alignment.centerRight,
//           margin: EdgeInsets.only(left: 8.0,top: 0.0,right: 8.0,bottom: 0.0),
//           child: Row(
//             children: [
//               GestureDetector(child: Image.asset('images/icons/ic_plus.png',width: 22,height: 22,),onTap: (){
//                 print('plus tap');
//                 data(1);
//               },),
//             ],
//           ) ,
//         ),
//       ],
//     ),
//   );
// }