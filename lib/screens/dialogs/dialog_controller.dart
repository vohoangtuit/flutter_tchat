import 'package:flutter/material.dart';
import 'package:tchat_app/base/base_dialog.dart';
import 'package:tchat_app/screens/dialogs/dialog_select_pictures.dart';
import 'package:tchat_app/screens/dialogs/dialog_view_single_image.dart';

import 'dialog_base_notify.dart';

class DialogController{
 final BuildContext context;

  DialogController(this.context);
  showBaseNotification(BaseDialog dialog, String title,String description){
    dialog = BaseNotification(title: title, description: description);
    showDialog(
      // barrierDismissible: false,// touch outside dismiss
        context: context,
        builder: (BuildContext context) => dialog
    );
  }
 showDialogRequestUpdatePicture(BaseDialog dialog,int type, Function(int type, int choose) callback){// todo define type 1 is avatar, 2 is cover; choose 1 take picture,2 is library
   dialog = DialogSelectPictures(type:type,callback:callback);
   showDialog(
     // barrierDismissible: false,// touch outside dismiss
       context: context,
       builder: (BuildContext context) => dialog
   );
 }
ShowDialogViewSingleImage(BaseDialog dialog, String url){
  dialog = DialogViewSingleImage(url: url);
  showDialog(
    // barrierDismissible: false,// touch outside dismiss
      context: context,
      builder: (BuildContext context) => dialog
  );
}
}