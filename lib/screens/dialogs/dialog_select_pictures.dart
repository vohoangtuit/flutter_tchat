import 'package:flutter/material.dart';
import 'package:tchat_app/base/base_dialog.dart';
import 'package:tchat_app/utils/const.dart';
import 'package:tchat_app/widget/text_style.dart';

class DialogSelectPictures extends BaseDialog{
  final void Function(int type, int choose) callback;
  final int type;
  DialogSelectPictures({this.type,this.callback});
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
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10,top:10,right: 10,bottom: 0),
          child:Column(
            children: [
              Text(type==PICTURE_TYPE_AVATAR?'Avatar':'Cover',style: smallTextGray(),),
              SizedBox(height: 10,),
              Divider(height: 0.5,),
              InkWell (
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center ,
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height:45,child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(type==PICTURE_TYPE_AVATAR?'View profile picture':'View full cover',style: mediumTextBlack(),),
                      ],
                    )),
                  ],
                ),
                onTap: (){
                  callback(type,CHOOSE_PICTURE_VIEW_PICTURE);
                  dismiss();
                },
              ),
              Divider(height: 0.5,),
              InkWell (
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(height:45, child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Take Photo',style: mediumTextBlack(),),
                        ],
                      )),
                    ],
                  ),
                onTap: (){
                    callback(type,CHOOSE_PICTURE_CAMERA);
                    dismiss();
                },
              ),
              Divider(height: 0.5,),
              InkWell (child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(height:45, child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    children: [
                      Text('Choose From Photos',style: mediumTextBlack(),),
                    ],
                  )),
                ],
              ),
                onTap: (){
                  callback(type,CHOOSE_PICTURE_LIBRARY);
                  dismiss();
                },
              ),
              Divider(height: 0.5,),
            ],
          )
        ),
      ],
    );

  }
}