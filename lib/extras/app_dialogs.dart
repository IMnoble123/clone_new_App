import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'constants.dart';

class AppDialogs {
  static Future<String> simpleSelectionDialog(
      BuildContext context, String title, String message,String posText) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Center(
                child: Text(
              title,
              style: const TextStyle(
                  color: AppColors.firstColor,
                  fontSize: 22,
                  ),
              textAlign: TextAlign.center,
            )),
            content: Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.phoneTextColor,
                    fontSize: 18,
                    )),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, AppConstants.CANCEL);
                      },
                      child: const Text(
                        'Dismiss',
                        style: TextStyle(
                            color: AppColors.firstColor,
                            fontSize: 18,
                            ),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, AppConstants.OK);
                      },
                      child: Text(
                        posText,
                        style: const TextStyle(
                            color: AppColors.firstColor,
                            fontSize: 18,
                            ),
                      )),
                ],
              )
            ],
          );
        });
  }

  

  static Future<String> simpleOkDialog(
      BuildContext context, String title, String message) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Center(
                child: Text(
              title,
              style: const TextStyle(
                  color: AppColors.firstColor, fontSize: 18,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            )),
            content: Text(
              message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.phoneTextColor,
                    fontSize: 16,
                    )),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context, AppConstants.OK);
                      },
                      child: const Text(
                        'Dismiss',
                        style: TextStyle(
                            color: AppColors.firstColor,
                            fontSize: 18,
                            ),
                      )),
                ],
              )
            ],
          );
        });
  }
}
