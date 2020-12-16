import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
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
      child: Stack(
        children: [
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
                  child: url.isNotEmpty ?
                  PhotoView(
                    maxScale: PhotoViewComputedScale.covered * 2.0,
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    initialScale: PhotoViewComputedScale.contained * 0.8, imageProvider: NetworkImage(url),)
                      : Image.asset('images/image_not-available.png', fit: BoxFit.fitHeight,
                  ),),

              ),
            ],
          ),
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
        ],

      ),);

  }

}
