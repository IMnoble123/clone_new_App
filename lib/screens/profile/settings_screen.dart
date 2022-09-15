import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/profile_controller.dart';
import 'package:podcast_app/db/db.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/share_prefs.dart';
import 'package:podcast_app/screens/login/login_screen.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/title_tile_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends GetView<ProfileController> {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchTotalSize();

    controller.isAgetRestrictionOff.value = AppConstants.age_restricted;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(
                  width: 150,
                  child: Divider(
                    color: AppColors.disableColor,
                  )),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explicit (Age restrictions) ',
                    style: TextStyle(color: Colors.white),
                  ),
                  Obx(() => Switch(
                      value: controller.isAgetRestrictionOff.value,
                      inactiveTrackColor: AppColors.iconColor,
                      onChanged: (v) {
                        controller.updateAgeRestriction(v);

                        AppConstants.age_restricted = v;

                        AppSharedPreference().saveBoolData(AppConstants.AGE_RESTRICTED, v);

                      })),
                  const SizedBox(
                    height: 10,
                  ),
                  /*const Text(
                    'Device Lock screen ',
                    style: TextStyle(color: Colors.white),
                  ),
                  const Text(
                    'Control your podcast from the lock screen when listening On another device.',
                    style: TextStyle(color: AppColors.textSecondaryColor),
                  ),
                  Obx(() => Switch(
                      value: controller.isDeviceLockOff.value,
                      inactiveTrackColor: AppColors.iconColor,
                      onChanged: (v) {
                        controller.updateDeviceLock(v);
                      })),
                  const SizedBox(
                    height: 10,
                  ),*/
                  Obx(
                    ()=> TitleTileView(
                      title: 'Storage',
                      subTitle: 'Downloads (${controller.totalSize.value.toStringAsFixed(2)}) MB',
                      callback: () {

                      },
                      isEditable: false,
                    ),
                  ),
                  TextButton(
                    onPressed: () {

                      AppDialogs.simpleSelectionDialog(context, "Confirmation?",
                          "Would you like to remove all downloaded files/folders", "Clear All")
                          .then((value) {
                        if (value == AppConstants.OK) {

                          deleteAllFiles(context);

                        }
                      });

                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: const Text(
                      'Remove all the downloads.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                    onPressed: () {

                      AppDialogs.simpleSelectionDialog(context, "Confirmation?",
                          "Would you like to clear the app cache", "Clear")
                          .then((value) {
                        if (value == AppConstants.OK) {

                          clearCache(context);

                        }
                      });

                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft),
                    child: const Text(
                      'Clear Cache.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void deleteAllFiles(context) async{

    Utility.deleteAllFiles(AppConstants.DOWNLOADS_FILES_DIRECTORY);

    TomTomDb().deleteAll().then((value){
      AppDialogs.simpleOkDialog(context, 'Success',
          "All files are removed from device/app storage.");
      controller.fetchTotalSize();
    });


  }

  void clearCache(context) async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    AppDialogs.simpleOkDialog(context, 'Success',
        "Cleared the app cache successfully. Re login requires.").then((value) async{

      Get.find<MainController>().tomtomPlayer.dispose();
      MainPage.isFirstBuild =true;
      await Get.delete<MainController>(force: true).then((value) => Get.offAll(const LoginScreen()));

    });

  }

}
