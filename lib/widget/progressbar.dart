import 'package:flutter/material.dart';

class ProgressBar {

  OverlayEntry _progressOverlayEntry;

  void show(BuildContext context){
    _progressOverlayEntry = _createdProgressEntry(context);
    Overlay.of(context).insert(_progressOverlayEntry);
  }

  void hide(){
    if(_progressOverlayEntry != null){
      _progressOverlayEntry.remove();
      _progressOverlayEntry = null;
    }
  }

  OverlayEntry _createdProgressEntry(BuildContext context) =>
      OverlayEntry(
          builder: (BuildContext context) =>
              Stack(
                children: <Widget>[
//                  Container(
//                    //color: Colors.lightBlue.withOpacity(0.5),
//                    color: Colors.grey.withOpacity(0.5),
//                  ),
                  new Opacity(
                    opacity: 0.3,
                    child: const ModalBarrier(dismissible: false, color: Colors.grey),
                  ),
                  Positioned(
                    top: screenHeight(context) / 2,
                    left: screenWidth(context) / 2,
                    child: CircularProgressIndicator(),
                  )

                ],

              )
      );

  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

}