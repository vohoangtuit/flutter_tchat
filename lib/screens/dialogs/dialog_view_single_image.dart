import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tchat_app/base/base_dialog.dart';
class DialogViewSingleImage extends BaseDialog {
  final String url;

  DialogViewSingleImage({this.url});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);// todo set full screen without status bar
    //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);// todo disable overlay status base
    this.context = context;
    dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      insetPadding: EdgeInsets.only(
          left: 0.0, top: 0.0, right: 0.0, bottom: 0.0),
      elevation: 0.0,
      backgroundColor: Colors.black,
      child: initUI(),
    );
    return dialog;


  }

  Widget initUI() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.arrow_back_rounded, color: Colors.white,),
                  ],
                ),
              ),
              onTap: () {
                dismiss();
              },
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height - 80,
                  child: url.isNotEmpty ? Image.network(
                    url, fit: BoxFit.fitHeight,) : Image.asset(
                    'images/cover.png',
                    fit: BoxFit.cover,
                  ),),

              ),
            ],
          ),
        ],
      ),);

  }

}
