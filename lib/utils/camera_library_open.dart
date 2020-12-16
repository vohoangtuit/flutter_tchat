import 'dart:io';

import 'package:image_picker/image_picker.dart';

class CameraLibraryOpening{
  final void Function(File file,int type) cameraCallback;
  CameraLibraryOpening(this.cameraCallback);
  Future cameraOpen(int type)async {
    File img = await ImagePicker.pickImage(source: ImageSource.camera);
    if (img != null) {
      cameraCallback(img, type);
    } else {
      cameraCallback(null, type);
    }
  }
  Future libraryOpen(int type) async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;
    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    File image = File(pickedFile.path);
    if (image != null) {
      cameraCallback(image, type);
    } else {
      cameraCallback(null, type);
    }
  }
}