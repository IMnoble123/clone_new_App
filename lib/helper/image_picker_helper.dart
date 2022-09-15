import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  ImagePickerHelper();

  static Future<XFile?> captureImage(
      {bool isCamera = true}) async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? pickedFile = await _picker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          maxHeight: 480,
          maxWidth: 640,
          imageQuality: 80);

      return pickedFile;


    } catch (err, str) {
      print('ERR => $err - $str');

      return null;
    }
  }
  static Future<XFile?> recordVideo(
      {bool isCamera = true}) async {
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? pickedFile = await _picker.pickVideo(source: isCamera?ImageSource.camera:ImageSource.gallery);
      return pickedFile;
    } catch (err, str) {
      print('ERR => $err - $str');

      return null;
    }
  }
}
