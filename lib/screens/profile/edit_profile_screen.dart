import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/profile_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/keys.dart';
import 'package:podcast_app/extras/share_prefs.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/btns/wrap_text_btn.dart';
import 'package:podcast_app/widgets/title_tile_view.dart';

class EditProfileScree extends GetView<ProfileController> {
  const EditProfileScree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      key: AppKeys.profileScaffoldState,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(
                  width: 125,
                  child: Divider(
                    color: AppColors.disableColor,
                  )),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 57,
                      backgroundColor: Colors.white54,
                      child: Obx(
                        () => CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              controller.userData.value.profileImage != null &&
                                      controller.userData.value.profileImage!
                                          .isNotEmpty
                                  ? controller.userData.value.profileImage!
                                  : AppConstants.dummyProfilePic),
                          radius: 55,
                        ),
                      ),
                    ),
                    Positioned.fill(
                        child: Material(
                      color: Colors.black.withOpacity(0.4),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () async {
                          final ImagePicker _picker = ImagePicker();
                          // Pick an image
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);

                          if (image != null) {
                            uploadImageToServer(context, image.path);
                          }

                        },
                        child: const Center(
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView(
                /* primary: false,
                shrinkWrap: true,*/
                itemExtent: 60,
                shrinkWrap: true,
                primary: false,
                children: [
                  Obx(
                    () => TitleTileView(
                      title: 'User Name',
                      subTitle: controller.userData.value.name ?? '',
                      callback: () {
                        controller.inputController.text =
                            controller.userData.value.name ?? '';
                        _displayTextInputDialog('Full Name', context)
                            .then((value) {
                          if (value != null && value.isNotEmpty) {
                            ApiService()
                                .putData(
                                    ApiKeys.UPDATE_RPOFILE_SUFFIX,
                                    ApiKeys.getProfileUpdateQuery(
                                        'fullname', value))
                                .then((value) => controller.fetchProfileInfo());
                          }
                        });
                      },
                    ),
                  ),
                  Obx(
                    () => TitleTileView(
                      title: 'Mobile Number',
                      isEditable: false,
                      subTitle:
                          controller.userData.value.mobile ?? '',
                      callback: () {
                        controller.inputController.text =
                            controller.userData.value.mobile ?? '';
                        _displayTextInputDialog('Mobile Number', context)
                            .then((value) {
                          if (value != null && value.isNotEmpty) {
                            if (value.length != 10) {
                              AppDialogs.simpleOkDialog(context, 'Failed',
                                  'please enter valid mobile number');
                              return;
                            }

                            ApiService()
                                .putData(
                                    ApiKeys.UPDATE_RPOFILE_SUFFIX,
                                    ApiKeys.getProfileUpdateQuery(
                                        'mobile', value))
                                .then((value) => controller.fetchProfileInfo());
                          }
                        });
                      },
                    ),
                  ),
                  Obx(
                    () => TitleTileView(
                      title: 'Email',
                      isEditable: true,
                      subTitle: controller.userData.value.email ?? '',
                      callback: () {
                        controller.inputController.text =
                            controller.userData.value.email ?? '';
                        _displayTextInputDialog('Email', context).then((value) {
                          if (value != null && value.isNotEmpty) {
                            if (!Utility.isValidEmail(value)) {
                              AppDialogs.simpleOkDialog(context, 'Failed',
                                  'please enter valid email address');
                              return;
                            }

                            ApiService()
                                .putData(
                                    ApiKeys.UPDATE_RPOFILE_SUFFIX,
                                    ApiKeys.getProfileUpdateQuery(
                                        'email', value))
                                .then((value) => controller.fetchProfileInfo());
                          }
                        });
                      },
                    ),
                  ),
                 const SizedBox(height: 8),
                  Obx(
                    () => TitleTileView(
                      title: 'DOB',
                      subTitle: controller.userData.value.dob != null &&
                              controller.userData.value.dob!.isNotEmpty
                          ? getServerToNormalDate(
                              controller.userData.value.dob!)
                          : '',
                      callback: () {
                        _showDatePicker(context);
                        /*String normalDob = "";
                        if (controller.userData.value.dob != null &&
                            controller.userData.value.dob!.isNotEmpty) {
                          normalDob = getServerToNormalDate(
                              controller.userData.value.dob!);
                        }

                        controller.inputController.text = normalDob;

                        _displayTextInputDialog('Date Of Birth', context,
                                isDob: true)
                            .then((value) {
                          if (value != null && value.isNotEmpty) {
                            if (value.length != 10 ||
                                !Utility.isValidDob(value, " ")) {
                              AppDialogs.simpleOkDialog(context, 'Failed',
                                  'please enter proper date of birth');
                              return;
                            }

                            ApiService()
                                .putData(
                                    ApiKeys.UPDATE_RPOFILE_SUFFIX,
                                    ApiKeys.getProfileUpdateQuery(
                                        'dob', getServerDate(value)))
                                .then((value) => controller.fetchProfileInfo());
                          }
                        });*/
                      },
                    ),
                  ),
                  /*Obx(
                    () => TitleTileView(
                      title: 'Gender',
                      subTitle: controller.userData.value.gender ?? '',
                      callback: () {
                        displayGenderDialog(context).then((value) {
                          if (value != null) {
                            print(value.name.toString());

                            ApiService()
                                .putData(
                                    ApiKeys.UPDATE_RPOFILE_SUFFIX,
                                    ApiKeys.getProfileUpdateQuery(
                                        'gender', value.name.toString()))
                                .then((value) => controller.fetchProfileInfo());
                          }
                        });

                        *//* controller.inputController.text =
                            controller.userData.value.gender ?? '';*//*

                        *//*_displayTextInputDialog('Gender', context)
                            .then((value) {
                          if (value != null && value.isNotEmpty) {
                            ApiService()
                                .putData(
                                    ApiKeys.UPDATE_RPOFILE_SUFFIX,
                                    ApiKeys.getProfileUpdateQuery(
                                        'gender', value.trim()))
                                .then((value) => controller.fetchProfileInfo());
                          }
                        });*//*
                      },
                    ),
                  ),*/
                ],
              ),
              /* const Text(
                'Gender',
                style: TextStyle(color: Colors.white),
              ),
              Obx(
                () => Row(
                  children: [
                    Radio<Gender>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      focusColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      value: Gender.Male,
                      groupValue: controller.gender.value,
                      onChanged: (value) {
                        controller.gender.value = value!;
                      },
                    ),
                    const Text(
                      'Male',
                      style: TextStyle(color: Colors.white),
                    ),
                    Radio<Gender>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      focusColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      value: Gender.FeMale,
                      groupValue: controller.gender.value,
                      onChanged: (value) {
                        controller.gender.value = value!;
                      },
                    ),
                    const Text(
                      'FeMale',
                      style: TextStyle(color: Colors.white),
                    ),
                    Radio<Gender>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      focusColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      value: Gender.Other,
                      groupValue: controller.gender.value,
                      onChanged: (value) {
                        controller.gender.value = value!;
                      },
                    ),
                    const Text(
                      'Other',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),*/
              /* Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  ListTile(
                    title: const Text('Male'),
                    leading: Radio<Gender>(
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.green),
                      focusColor: MaterialStateColor.resolveWith((states) => Colors.green),
                      value: Gender.Male,
                      groupValue: controller.gender.value,
                      onChanged: (value) {
                        controller.gender.value = value!;
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('FeMale'),
                    leading: Radio<Gender>(
                      fillColor: MaterialStateColor.resolveWith((states) => Colors.green),
                      focusColor: MaterialStateColor.resolveWith((states) => Colors.green),
                      value: Gender.FeMale,
                      groupValue: controller.gender.value,
                      onChanged: (value) {
                        controller.gender.value = value!;
                      },
                    ),
                  ),
                ],
              ),*/

              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void uploadImageToServer(BuildContext context, String path) async {

    Get.find<MainController>().showProgress.value = true;

    final response = await ApiService().uploadFile(path);

    ResponseData responseData = ResponseData.fromJson(response);

    /*if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {

      print(responseData.response!);
      controller.profilePicPath.value = responseData.response!;

      AppSharedPreference().saveStringData(AppConstants.PROFILE_PIC_PATH, responseData.response!);

      AppDialogs.simpleOkDialog(context, 'Success',
          "Successfully updated the profile pic.");
    }*/

    Get.find<MainController>().showProgress.value = false;

    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      print(responseData.response!);

      ApiService()
          .putData(
              ApiKeys.UPDATE_RPOFILE_SUFFIX,
              ApiKeys.getProfileUpdateQuery(
                  "profile_image", responseData.response!))
          .then((value) => controller.fetchProfileInfo());

      AppSharedPreference().saveStringData(
          AppConstants.PROFILE_PIC_PATH, responseData.response!);

      AppDialogs.simpleOkDialog(
          context, 'Success', "Successfully updated the profile pic.");
    } else {
      AppDialogs.simpleOkDialog(context, 'Failed',
          responseData.response ?? "unable to process request");
    }
  }

  //static GlobalKey<FormFieldState> _abcKey = GlobalKey<FormFieldState>();

  /*Future<String> _displayTextInputDialogx(BuildContext context) async {
    return await showDialog(
        context: context,
        useRootNavigator: false,
        builder: (c) {
          return AlertDialog(
            title: const Text('New Collection'),
            content: TextField(
              controller: controller.inputController,
              key: AppKeys.collectionTfKey,
              decoration:
                  const InputDecoration(hintText: "Enter collection name"),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WrapTextButton(
                  title: 'Cancel',
                  callback: () {
                    controller.inputController.clear();
                    Navigator.of(context, rootNavigator: false).pop();
                  },
                  textColor: AppColors.firstColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WrapTextButton(
                  title: 'CREATE',
                  callback: () {
                    if (controller
                        .inputController
                        .text
                        .isNotEmpty) {
                      Navigator.of(context, rootNavigator: false).pop(controller.inputController.text);
                    }
                  },
                  textColor: AppColors.firstColor,
                ),
              ),
            ],
          );
        });
  }*/

  Future<String> _displayTextInputDialog(String title, BuildContext context,
      {isDob = false}) async {
    //String fieldValue = ;

    return await showDialog(
        context: context,
        useRootNavigator: false,
        builder: (c) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller.inputController,
              key: AppKeys.collectionTfKey,
              autofocus: true,
              inputFormatters: isDob
                  ? [
                      MaskTextInputFormatter(
                          mask: "## ## #### ", filter: {"#": RegExp(r'[0-9]')})
                    ]
                  : [],
              // key: AppKeys.collectionTfKey,
              decoration: const InputDecoration(hintText: ""),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WrapTextButton(
                  title: 'Cancel',
                  callback: () {
                    Navigator.pop(c, "");
                  },
                  textColor: AppColors.firstColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WrapTextButton(
                  title: 'Save',
                  callback: () {
                    Navigator.pop(c, controller.inputController.text);
                  },
                  textColor: AppColors.firstColor,
                ),
              ),
            ],
          );
        });
  }

  String getServerDate(String input) {
    var inputFormat = DateFormat('dd MM yyyy');
    var inputDate = inputFormat.parse(input); // <-- dd/MM 24H format

    var outputFormat = DateFormat('yyyy-MM-dd');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  String getServerToNormalDate(String input) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(input); // <-- dd/MM 24H format

    var outputFormat = DateFormat('dd MM yyyy');
    var outputDate = outputFormat.format(inputDate);

    return outputDate;
  }

  Future<Gender> displayGenderDialog(context) async {
    return await showDialog(
        context: context,
        useRootNavigator: false,
        builder: (c) {
          return AlertDialog(
            title: const Text('Gender'),
            content: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text(
                      'Male',
                      style: TextStyle(color: AppColors.firstColor),
                    ),
                    leading: Radio<Gender>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      focusColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      value: Gender.Male,
                      groupValue: controller.gender.value,
                      onChanged: (value) {
                        controller.gender.value = value!;
                      },
                    ),
                    onTap: () {
                      controller.gender.value = Gender.Male;
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Female',
                      style: TextStyle(color: AppColors.firstColor),
                    ),
                    leading: Radio<Gender>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      focusColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      value: Gender.Female,
                      groupValue: controller.gender.value,
                      onChanged: (value) {
                        controller.gender.value = value!;
                      },
                    ),
                    onTap: () {
                      controller.gender.value = Gender.Female;
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Other',
                      style: TextStyle(color: AppColors.firstColor),
                    ),
                    leading: Radio<Gender>(
                      fillColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      focusColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.firstColor),
                      value: Gender.Other,
                      groupValue: controller.gender.value,
                      onChanged: (value) {
                        controller.gender.value = value!;
                      },
                    ),
                    onTap: () {
                      controller.gender.value = Gender.Other;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WrapTextButton(
                  title: 'Cancel',
                  callback: () {
                    Navigator.pop(c);
                  },
                  textColor: AppColors.firstColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WrapTextButton(
                  title: 'Save',
                  callback: () {
                    Navigator.pop(c, controller.gender.value);
                  },
                  textColor: AppColors.firstColor,
                ),
              ),
            ],
          );
        });
  }

  void _showDatePicker(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  buildMaterialDatePicker(BuildContext context) async {
    DateTime today = DateTime.now();
    DateTime? initialDate;
    if (controller.userData.value.dob != null &&
        controller.userData.value.dob!.isNotEmpty) {
      List<String> prevDate =
          getServerToNormalDate(controller.userData.value.dob!).split(" ");
      print(prevDate);
      initialDate = DateTime(int.parse(prevDate[2]), int.parse(prevDate[1]),
          int.parse(prevDate[0]));
    } else {
      initialDate =
          DateTime(today.year - controller.minimumAge, today.month, today.day);
    }

    final DateTime? dateTime = await showDatePicker(
        context: context,
        //firstDate: DateTime(1950),
        firstDate: DateTime(today.year - controller.maximumAge),
        initialDate: initialDate,
        // initialDate: DateTime.now(),
        //initialDatePickerMode: DatePickerMode.year,
        lastDate: DateTime(
            today.year - controller.minimumAge, today.month, today.day),
        helpText: 'Date of Birth',
        builder: (context, child) {
          return Theme(
              data: ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.highContrastLight(
                      primary: AppColors.firstColor),
                  dialogBackgroundColor: Colors.white),
              child: child!);
        });

    controller.selectedDate = controller.dateFormat.format(dateTime!);
    print(controller.selectedDate);

    updateDob(controller.selectedDate!);
  }

  buildCupertinoDatePicker(BuildContext context) async {
    DateTime today = DateTime.now();

    DateTime? initialDate;

    if (controller.userData.value.dob != null &&
        controller.userData.value.dob!.isNotEmpty) {
      List<String> prevDate =
          getServerToNormalDate(controller.userData.value.dob!).split(" ");
      print(prevDate);
      initialDate = DateTime(int.parse(prevDate[2]), int.parse(prevDate[1]),
          int.parse(prevDate[0]));
    } else {
      initialDate =
          DateTime(today.year - controller.minimumAge, today.month, today.day);
    }

    DateTime pickedDate = await showModalBottomSheet(
        context: AppKeys.mainScaffoldState.currentState!.context,
        builder: (BuildContext builder) {
          DateTime tempPickedDate = controller.selectedDateTime ??
              DateTime(
                  today.year - controller.minimumAge, today.month, today.day);
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.firstColor),
                      ),
                      onPressed: () {
                        Navigator.of(
                                AppKeys.mainScaffoldState.currentState!.context)
                            .pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text(
                        'Done',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.firstColor),
                      ),
                      onPressed: () {
                        Navigator.of(
                                AppKeys.mainScaffoldState.currentState!.context)
                            .pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    onDateTimeChanged: (picked) {
                      tempPickedDate = picked;

                      /* setState(() {
                          dobController.text = _dateFormat.format(picked);
                          // selectedDob = picked as String?;
                        });*/
                    },
                    initialDateTime: initialDate,
                    // minimumYear: 1950,
                    minimumYear: today.year - controller.maximumAge,
                    maximumYear: today.year - controller.minimumAge,
                  ),
                ),
              ],
            ),
          );
        });

    if (pickedDate != null && pickedDate != controller.selectedDateTime) {
      controller.selectedDateTime = pickedDate;
      controller.selectedDate = controller.dateFormat.format(pickedDate);
      updateDob(controller.selectedDate!);
    }
  }

  void updateDob(String selectedDate) {
    ApiService()
        .putData(ApiKeys.UPDATE_RPOFILE_SUFFIX,
            ApiKeys.getProfileUpdateQuery('dob', getServerDate(selectedDate)))
        .then((value) => controller.fetchProfileInfo());
  }
}

enum Gender { Male, Female, Other }
