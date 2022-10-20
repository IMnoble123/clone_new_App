import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/helper/image_picker_helper.dart';
import 'package:podcast_app/screens/login/login_screen.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:url_launcher/url_launcher.dart';

class Utility {
  static getRequiredDateFormat(String s) {

    print(s);

    if (s.isEmpty) return "";

    DateFormat inputFormat = DateFormat('dd-MMM-yyyy HH:mm');

    final DateTime date = inputFormat.parse(s);
    final DateFormat formatter = DateFormat('dd MMM yy');
    final String formatted = formatter.format(date);
    print(formatted); // something like 2013-04-20

    return formatted;
  }

  static showRegistrationPromotion(context) {
    AppDialogs.simpleSelectionDialog(context, "Login Required",
            "Registered users only have this permission", "LOGIN")
        .then((value) async {
      if (value == AppConstants.OK) {
        Get.find<MainController>().tomtomPlayer.dispose();
        MainPage.isFirstBuild = true;
        await Get.delete<MainController>(force: true)
            .then((value) => Get.offAll(const LoginScreen()));
      }
    });
  }

  static showSnackBar(context, message) {
    final SnackBar snackBar = SnackBar(
      content: Text(message),
      backgroundColor: AppColors.firstColor,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void hideKeyword(BuildContext context) {
    // FocusScope.of(context).unfocus();
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static bool isPasswordCompliant(String password) {
    if (password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(RegExp(r'[_!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= 8;

    return hasDigits &
        hasUppercase &
        hasLowercase &
        hasSpecialCharacters &
        hasMinLength;
  }

  static bool isValidDob(String text, String splitter) {
    if (text.isEmpty) return true;

    final components = text.split(splitter);
    if (components.length == 3) {
      final day = int.tryParse(components[0]);
      final month = int.tryParse(components[1]);
      final year = int.tryParse(components[2]);
      if (day != null && month != null && year != null) {
        try {
          final date = DateTime(year, month, day);
          if (date.year == year && date.month == month && date.day == day) {
            return true;
          }
        } catch (e) {
          log(e.toString());
          return false;
        }
      }
    }

    return false;
  }

  static bool isValidEmail(String input) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,3}))$')
        .hasMatch(input);
  }

  static void openUrls(BuildContext context, String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch';
  }

  static void composeEmail(BuildContext context, String email,
      {body = ''}) async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(
          <String, String>{'subject': 'TomTom Podcast', 'body': body}),
    );

    launchUrl(Uri.parse(emailLaunchUri.toString()));
  }

  static Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory

    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
        Directory('${_appDocDir.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  Future<void> getDir() async {
    List<FileSystemEntity> _folders;
    final directory = await getApplicationDocumentsDirectory();
    final dir = directory.path;
    String pdfDirectory = '$dir/';
    final myDir = Directory(pdfDirectory);
    _folders = myDir.listSync(recursive: true, followLinks: false);
    print(_folders);
  }

  static Future<double> dirStatSync(String dirName) async {
    int fileNum = 0;
    int totalSize = 0;
    var dirPath = await createFolderInAppDocDir(dirName);
    var dir = Directory(dirPath);
    try {
      if (dir.existsSync()) {
        dir
            .listSync(recursive: true, followLinks: false)
            .forEach((FileSystemEntity entity) {
          if (entity is File) {
            fileNum++;
            totalSize += entity.lengthSync();
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }

    return totalSize / (1024 * 1024);
  }

  static void deleteAllFiles(String dirName) async {
    var dirPath = await createFolderInAppDocDir(dirName);
    var dir = Directory(dirPath);
    dir.deleteSync(recursive: true);
  }

  static getCurrentTime() {
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  static void deleteAudio(String path) async {
    File file = File(path);
    await file.delete();
  }

  static String formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  static Future<String> openPhotos({bool camera = false}) async {
    XFile? pickedFile = await ImagePickerHelper.captureImage(isCamera: camera);
    if (pickedFile != null) {
      final File file = File(pickedFile.path);
      String imgPath = file.path;

      return imgPath;
    }

    return '';
  }

  static String getDeviceOs() {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return "IOS";
    }

    return "";
  }

  static void showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          );
        });
  }
}
