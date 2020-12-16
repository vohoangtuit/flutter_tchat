import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseDialog extends  StatelessWidget{
  Dialog dialog;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    this.context =context;
    if(dialog!=null){
      Navigator.pop(this.context);
    }
    dialog = Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.black,
    );
    return dialog;
  }
  dismiss() {
    if (context != null) {
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);// todo disable overlay status base
      Navigator.pop(context);
    }
  }
}