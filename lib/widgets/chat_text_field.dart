import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/chat_textfield_controller.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/utils/utility.dart';

class ChatTextField extends StatefulWidget {
  final BuildContext mainContext;

  const ChatTextField({Key? key, required this.mainContext}) : super(key: key);

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  final controller = Get.put(ChatTextFieldController());

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    //SystemChannels.textInput.invokeMethod('TextInput.show');

    //FocusScope.of(context).requestFocus(focusNode);

    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        //margin: const EdgeInsets.all(5.0),
        margin: EdgeInsets.only(
            left: 5.0,
            right: 5.0,
            top: 5.0,
            bottom: MediaQuery.of(context).viewInsets.bottom+30),
        decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: Obx(
          () => controller.enableAudioView.value
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.isRecording.value = false;
                        controller.enableAudioView.value = false;
                        controller.isPlayRecodedAudio.value = false;
                        controller.isRecordingCompleted.value = false;

                        Utility.deleteAudio(controller.recordPath.value);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: AppColors.firstColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Utility.formatNumber(
                                controller.recordDuration.value ~/ 60) +
                            ':' +
                            Utility.formatNumber(
                                controller.recordDuration.value % 60),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.firstColor),
                      ),
                    ),
                    controller.isRecordingCompleted.value
                        ? controller.isPlayRecodedAudio.value
                            ? IconButton(
                                onPressed: () async {
                                  pauseAudio();
                                },
                                icon: const Icon(
                                  Icons.pause_circle_filled_outlined,
                                  color: AppColors.firstColor,
                                ))
                            : IconButton(
                                onPressed: () async {
                                  /* await controller.recorder.resume();
                                      controller.isRecordingPaused.value =
                                          false;*/
                                  playAudio();
                                },
                                icon: const Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: AppColors.firstColor,
                                ))
                        : IconButton(
                            onPressed: () async {
                              stopRecording(context);
                            },
                            icon: const Icon(
                              Icons.stop_circle,
                              color: AppColors.firstColor,
                            )),
                    controller.isRecordingCompleted.value
                        ? Material(
                            color: Colors.transparent,
                            child: IconButton(
                                onPressed: () {
                                  if (controller.isRecording.value) {
                                    stopRecording(context);
                                  }

                                  controller.enableAudioView.value = false;
                                  controller.isPlayRecodedAudio.value = false;
                                  controller.isRecording.value = false;
                                  controller.isRecordingCompleted.value = false;

                                  uploadImageToServer(
                                          context, controller.recordPath.value)
                                      .then((value) {
                                    if (value.isNotEmpty) {
                                      print(value);
                                      controller.sendHtmlMessage(
                                          context, getHtmlData(value, false));
                                      // controller.sendHtmlMessage(getHtmlData(value));
                                    }
                                  });
                                },
                                icon: const Icon(
                                  Icons.send,
                                  color: AppColors.firstColor,
                                )))
                        : const SizedBox.shrink()
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                        color: Colors.transparent,
                        child: IconButton(
                            onPressed: () async {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  /*shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  topLeft:
                                                      Radius.circular(15))),*/
                                  context: context,
                                  builder: (builder) {
                                    return Container(
                                      /*padding:
                                                  const EdgeInsets.all(8.0),*/
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Material(
                                            child: ListTile(
                                              leading: const Icon(
                                                Icons.image_outlined,
                                                color: AppColors.firstColor,
                                              ),
                                              title: const Text(
                                                'Photos & Images',
                                                style: TextStyle(
                                                    color:
                                                        AppColors.firstColor),
                                              ),
                                              onTap: () async {
                                                Navigator.pop(
                                                    widget.mainContext);

                                                openGallery(widget.mainContext);
                                              },
                                            ),
                                          ),
                                          Material(
                                            child: ListTile(
                                              leading: const Icon(
                                                Icons.audio_file_outlined,
                                                color: AppColors.firstColor,
                                              ),
                                              title: const Text(
                                                'Audios & Music',
                                                style: TextStyle(
                                                    color:
                                                        AppColors.firstColor),
                                              ),
                                              onTap: () async {
                                                Navigator.pop(
                                                    widget.mainContext);

                                                openAudio(widget.mainContext);
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          ListTile(
                                            title: const Text(
                                              'Cancel',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColors.firstColor,
                                                  fontSize: 20),
                                            ),
                                            onTap: () {
                                              Navigator.pop(widget.mainContext);
                                            },
                                            tileColor: Colors.white,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: const CircleAvatar(
                              backgroundColor: AppColors.firstColor,
                              radius: 10,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ))),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        textAlign: TextAlign.start,
                        scrollPadding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom + 100),
                        maxLines: null,
                        focusNode: focusNode,
                        controller: controller.messageController,
                        style: const TextStyle(
                            fontSize: 14.0, color: AppColors.phoneTextColor),
                        decoration: InputDecoration(
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                          fillColor: Colors.white.withOpacity(0.4),
                          alignLabelWithHint: true,
                          hintText: 'Enter Comment',
                          counterText: "",
                        ),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.send,
                        onEditingComplete: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          Get.find<MainController>()
                              .enableCommentEditField
                              .value = false;

                          controller.sendMessage(context);
                        },
                      ),
                    ),
                    Obx(
                      () => controller.message.isNotEmpty
                          ? Material(
                              color: Colors.transparent,
                              child: IconButton(
                                  onPressed: () {
                                    if (controller
                                        .messageController.text.isNotEmpty) {
                                      controller.sendMessage(context);

                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      Get.find<MainController>()
                                          .enableCommentEditField
                                          .value = false;
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: AppColors.firstColor,
                                  )))
                          : Material(
                              color: Colors.transparent,
                              child: IconButton(
                                  onPressed: () {
                                    recordAudio();
                                  },
                                  icon: const Icon(
                                    Icons.mic,
                                    color: AppColors.firstColor,
                                  )),
                            ), /*Material(
                          color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  //splashColor: AppColors.firstColor.withOpacity(0.25),
                                  onTapDown: (e){
                                        print(e.localPosition);

                                        recordAudio();

                                  },
                                  onTap: (){},
                                  onTapUp: (e){
                                    stopRecording(context);
                                  },
                                  child: const Icon(
                                      Icons.mic,
                                      color: AppColors.firstColor,
                                    ),
                                ),
                              ),
                            ),*/
                    )
                  ],
                ),
        ),
      ),
    );

    /*return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: Obx(
          () => controller.enableAudioView.value
              ? Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.isRecording.value = false;
                        controller.enableAudioView.value = false;
                        controller.isPlayRecodedAudio.value = false;
                        controller.isRecordingCompleted.value = false;

                        Utility.deleteAudio(controller.recordPath.value);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: AppColors.firstColor,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        Utility.formatNumber(
                                controller.recordDuration.value ~/ 60) +
                            ':' +
                            Utility.formatNumber(
                                controller.recordDuration.value % 60),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.firstColor),
                      ),
                    ),
                    controller.isRecordingCompleted.value
                        ? controller.isPlayRecodedAudio.value
                            ? IconButton(
                                onPressed: () async {
                                  pauseAudio();
                                },
                                icon: const Icon(
                                  Icons.pause_circle_filled_outlined,
                                  color: AppColors.firstColor,
                                ))
                            : IconButton(
                                onPressed: () async {
                                  */ /* await controller.recorder.resume();
                                      controller.isRecordingPaused.value =
                                          false;*/ /*
                                  playAudio();
                                },
                                icon: const Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: AppColors.firstColor,
                                ))
                        : IconButton(
                            onPressed: () async {
                              stopRecording(context);
                            },
                            icon: const Icon(
                              Icons.stop_circle,
                              color: AppColors.firstColor,
                            )),
                    Material(
                        color: Colors.transparent,
                        child: IconButton(
                            onPressed: () {
                              if (controller.isRecording.value) {
                                stopRecording(context);
                              }

                              controller.enableAudioView.value = false;
                              controller.isPlayRecodedAudio.value = false;
                              controller.isRecording.value = false;
                              controller.isRecordingCompleted.value = false;

                              uploadImageToServer(
                                      context, controller.recordPath.value)
                                  .then((value) {
                                if (value.isNotEmpty) {
                                  print(value);
                                  controller.sendHtmlMessage(
                                      getHtmlData(value, false));
                                  // controller.sendHtmlMessage(getHtmlData(value));
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.send,
                              color: AppColors.firstColor,
                            )))
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                        color: Colors.transparent,
                        child: IconButton(
                            onPressed: () async {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  */ /*shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  topLeft:
                                                      Radius.circular(15))),*/ /*
                                  context: context,
                                  builder: (builder) {
                                    return Container(
                                      */ /*padding:
                                                  const EdgeInsets.all(8.0),*/ /*
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Material(
                                            child: ListTile(
                                              leading: const Icon(
                                                Icons.image_outlined,
                                                color: AppColors.firstColor,
                                              ),
                                              title: const Text(
                                                'Photos & Images',
                                                style: TextStyle(
                                                    color:
                                                        AppColors.firstColor),
                                              ),
                                              onTap: () async {
                                                Navigator.pop(widget.mainContext);

                                                openGallery(widget.mainContext);
                                              },
                                            ),
                                          ),
                                          Material(
                                            child: ListTile(
                                              leading: const Icon(
                                                Icons.audio_file_outlined,
                                                color: AppColors.firstColor,
                                              ),
                                              title: const Text(
                                                'Audios & Music',
                                                style: TextStyle(
                                                    color:
                                                        AppColors.firstColor),
                                              ),
                                              onTap: () async {
                                                Navigator.pop(widget.mainContext);

                                                openAudio(widget.mainContext);
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 3,
                                          ),
                                          ListTile(
                                            title: const Text(
                                              'Cancel',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: AppColors.firstColor,
                                                  fontSize: 20),
                                            ),
                                            onTap: () {
                                              Navigator.pop(widget.mainContext);
                                            },
                                            tileColor: Colors.white,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: const CircleAvatar(
                              backgroundColor: AppColors.firstColor,
                              radius: 10,
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ))),
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        textAlign: TextAlign.start,
                        maxLines: null,
                        focusNode: focusNode,
                        controller: controller.messageController,
                        style: const TextStyle(
                            fontSize: 14.0, color: AppColors.phoneTextColor),
                        decoration: const InputDecoration(
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: InputBorder.none,
                          */ /*border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30.0)),
                              borderSide: BorderSide(
                                  color: AppColors.disableColor, width: 0.2)),*/ /*
                          contentPadding: EdgeInsets.symmetric(horizontal: 5),
                          fillColor: Colors.white,
                          alignLabelWithHint: true,
                          hintText: 'Enter Comment',
                          counterText: "",
                        ),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.send,
                        onEditingComplete: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                         Get.find<MainController>().enableCommentEditField.value = false;

                          controller.sendMessage();
                        },
                      ),
                    ),
                    Obx(
                      () => controller.message.isNotEmpty
                          ? Material(
                              color: Colors.transparent,
                              child: IconButton(
                                  onPressed: () {
                                    if (controller
                                        .messageController.text.isNotEmpty) {

                                      controller.sendMessage();

                                      FocusManager.instance.primaryFocus?.unfocus();
                                      Get.find<MainController>().enableCommentEditField.value = false;

                                    }
                                  },
                                  icon: const Icon(
                                    Icons.send,
                                    color: AppColors.firstColor,
                                  )))
                          : Material(
                              color: Colors.transparent,
                              child: IconButton(
                                  onPressed: () {
                                    recordAudio();
                                  },
                                  icon: const Icon(
                                    Icons.mic,
                                    color: AppColors.firstColor,
                                  )),
                            ), */ /*Material(
                          color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GestureDetector(
                                  //splashColor: AppColors.firstColor.withOpacity(0.25),
                                  onTapDown: (e){
                                        print(e.localPosition);

                                        recordAudio();

                                  },
                                  onTap: (){},
                                  onTapUp: (e){
                                    stopRecording(context);
                                  },
                                  child: const Icon(
                                      Icons.mic,
                                      color: AppColors.firstColor,
                                    ),
                                ),
                              ),
                            ),*/ /*
                    )
                  ],
                ),
        ),
      ),
    );*/
  }

  void sendMessage(String text) {}

  String getHtmlData(String url, bool isImage) {
    String htmlData = "";

    print(url);

    String lower_url = url..toLowerCase();

    if (isImage) {
      return imgTag(Uri.encodeFull(url));

      // }else if(lower_url.contains('.mp3')||lower_url.contains('.wav')||lower_url.contains('.ogg')){
    } else {
      return audioTag(Uri.encodeFull(url));
    }

    return htmlData;
  }

  String imgTag(String url) {
    return "<img src=\"$url\" alt=\"$url\" style=\"max-height: 100px;max-width: 147px;\">";
  }

  String audioTag(String url) {
    return "<audio src=\"$url\" controls preload=\"auto\" type=\"audio/mpeg\"></audio>";
  }

  void recordAudio() async {
    await controller.recorder.hasPermission();

    controller.isRecording.value = true;
    controller.enableAudioView.value = true;

    /*Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File('$tempPath/record_test.mp3');*/

    // final path = '${controller.localDirectory}/record_test.mp3';
    final path =
        '${controller.localDirectory}record_${Utility.getCurrentTime()}.m4a';
    File file = File(path);
    await file.create();

    controller.recordPath.value = File.fromUri(Uri.parse(file.path)).path;

    await controller.recorder.start(path: controller.recordPath.value);
    // await controller.recorder.start(path: file.path);
    // await controller.recorder.start(path: controller.recordPath.value);
    controller.isNewAudio.value = true;

    startTimer();
  }

  void stopRecording(context) async {
    controller.isRecordingCompleted.value = true;
    controller.recordTimer?.cancel();
    controller.recordPath.value = (await controller.recorder.stop())!;
    print('Audio Path :${controller.recordPath.value}');

    controller.isRecording.value = false;

    //uploadImageToServer(context, controller.recordPath.value);
    // uploadImageToServer(context, File.fromUri(Uri.parse(controller.recordPath.value)).path);
  }

  void startTimer() {
    controller.recordDuration.value = 0;
    controller.recordTimer?.cancel();
    controller.recordTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      //if (controller.isRecordingPaused.value) return;
      controller.recordDuration.value++;
    });
  }

  void pauseAudio() async {
    await controller.audioPlayer?.pause();

    controller.isPlayRecodedAudio.value = false;
  }

  void playAudio() async {
    if (!controller.isNewAudio.value) {
      controller.audioPlayer?.resume();
      controller.isPlayRecodedAudio.value = true;
      return;
    }

    //AudioPlayer? audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

    // await controller.audioPlayer.play(Uri.parse(controller.recordPath.value).path,isLocal: true).then((value) {
    try {
      await controller.audioPlayer?.play(
          File.fromUri(Uri.parse(controller.recordPath.value)).path,
          isLocal: true);
      controller.isPlayRecodedAudio.value = true;
      // await controller.audioPlayer.play(controller.recordPath.value,isLocal: true);

      controller.isNewAudio.value = false;
    } catch (e) {
      e.printError();
    }
  }

  void openGallery(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);

    if (result != null) {
      File file = File(result.files.single.path!);

      uploadImageToServer(context, file.absolute.path).then((value) {
        if (value.isNotEmpty) {
          print(value);
          controller.sendHtmlMessage(context, getHtmlData(value, true));
          // controller.sendHtmlMessage(getHtmlData(value));
        }
      });
    } else {
      // User canceled the picker
    }
  }

  void openAudio(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.audio, allowMultiple: false);

    if (result != null) {
      File file = File(result.files.single.path!);

      uploadImageToServer(context, file.absolute.path).then((value) {
        if (value.isNotEmpty) {
          print(value);
          controller.sendHtmlMessage(context, getHtmlData(value, false));
          // controller.sendHtmlMessage(getHtmlData(value));
        }
      });
    } else {
      // User canceled the picker
    }
  }

  Future<String> uploadImageToServer(BuildContext context, String path) async {
    String uploadedUrl = "";

    controller.isLoading.value = true;

    final response = await ApiService().uploadFile(path);

    ResponseData responseData = ResponseData.fromJson(response);

    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      print(responseData.response!);

      uploadedUrl = responseData.response!;
    } else {
      AppDialogs.simpleOkDialog(
          context, 'Failed', responseData.response ?? "Failed to upload");
      uploadedUrl = "";
    }

    controller.isLoading.value = false;

    return uploadedUrl;
  }
}
