import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/db/db.dart';
import 'package:podcast_app/db/db_podcast.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/dynamic_links_service.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/screens/sub_screens/add_collections_screen.dart';
import 'package:podcast_app/screens/sub_screens/report_screen.dart';
import 'package:podcast_app/utils/utility.dart';

import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

class PodcastMoreOptionsScreen extends GetView<MainController> {
  const PodcastMoreOptionsScreen({Key? key}) : super(key: key);

  static String dummy =
      ' <!doctype html> <html lang="en"> <head> <meta property="og:title" content="TomTom Title" /> <meta property="og:description" content="Sample Description" /> <meta property="og:image" content="https://images.pexels.com/photos/302743/pexels-photo-302743.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500" /> <meta property="og:url" content="https://tomtompodcast.page.link/qL6j" /></head></html>';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                    size: 30,
                  )),
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                'images/play.png',
                width: 50,
                height: 50,
              ),
              const Text(
                'Play',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                  width: 150,
                  child: Divider(
                    color: AppColors.disableColor,
                  )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  controller.currentPodcast!.description!.isNotEmpty
                      ? controller.currentPodcast!.description!
                      : '',
                  style: const TextStyle(
                      color: AppColors.textSecondaryColor, fontSize: 14),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Podcaster : ${controller.currentPodcast!.rjname!.isNotEmpty ? controller.currentPodcast!.rjname! : ''}',
                    style: const TextStyle(
                        color: AppColors.textSecondaryColor, fontSize: 12),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Date : ${controller.currentPodcast!.broadcastDate!.isNotEmpty ? Utility.getRequiredDateFormat(controller.currentPodcast!.broadcastDate!) : ''} ',
                    style: const TextStyle(
                        color: AppColors.textSecondaryColor, fontSize: 12),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Divider(
                  color: AppColors.disableColor,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: RawScrollbar(
                    thumbVisibility: true,
                    thumbColor: AppColors.firstColor,
                    radius: const Radius.circular(20),
                    thickness: 2,
                    child: ListView(
                      itemExtent: 50,
                      children: [
                        Stack(
                          children: [
                            listTile('images/download_icon.png', 'Download',
                                () {
                              if (CommonNetworkApi().mobileUserId != "-1") {
                                if (!controller.downloadInProgress.value) {
                                  controller.downloadProgress.value = 0;
                                  startDownloadPodcast(context);
                                }
                              } else {
                                Utility.showRegistrationPromotion(context);
                              }
                            }),
                            Positioned(
                              child: Obx(
                                () => controller.downloadProgress.value != 0 &&
                                        controller.downloadProgress.value != 100
                                    ? Center(
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                            backgroundColor: AppColors
                                                .firstColor
                                                .withOpacity(0.4),
                                            value: controller
                                                    .downloadProgress.value /
                                                100,
                                            color: AppColors.firstColor,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                              right: 0,
                              top: 0,
                              bottom: 0,
                            )
                          ],
                        ),
                        listTile('images/share_circle.png', 'Share', () {
                          if (CommonNetworkApi().mobileUserId != "-1") {
                            DynamicLinksService.createDynamicLink(
                                    controller.currentPodcast!)
                                .then((value) {
                              print(value);
                              Share.share(value, subject: 'Look what i made');
                              // Share.share(HtmlWidget(dummy).html);
                            });
                          } else {
                            Utility.showRegistrationPromotion(context);
                          }

                          //sharePodcast();
                        }),
                        listTile('images/star.png', 'Add to favorites', () {
                          if (CommonNetworkApi().mobileUserId != "-1") {
                            ApiService()
                                .postData(
                                    ApiKeys.FAV_SUFFIX,
                                    ApiKeys.getFavouriteQuery(
                                        controller.podcastId.value),
                                    ageNeeded: false)
                                .then((value) => showResponse(context, value));
                          } else {
                            Utility.showRegistrationPromotion(context);
                          }
                        }),
                        listTile('images/add_play_list.png', 'Add to play list',
                            () {
                          print(CommonNetworkApi().mobileUserId);
                          if (CommonNetworkApi().mobileUserId != "-1") {
                            showGeneralDialog(
                                context: context,
                                pageBuilder:
                                    (context, animation, secondAnimation) {
                                  return AddPlayListCollectionScreen(
                                      controller.currentPodcast!.podcastId!);
                                });
                          } else {
                            Utility.showRegistrationPromotion(context);
                            /*AppDialogs.simpleSelectionDialog(
                                    context,
                                    "Login Required",
                                    "you will need to login permission for this feature ",
                                    "LOGIN")
                                .then((value) async {
                              if (value == AppConstants.OK) {
                                Get.find<MainController>().tomtomPlayer.dispose();
                                MainPage.isFirstBuild = true;
                                await Get.delete<MainController>(force: true).then(
                                    (value) => Get.offAll(const LoginScreen()));
                              }
                            });*/
                          }
                        }, addTrail: true),
                        listTile('images/timer.png', 'Listen later', () {
                          if (CommonNetworkApi().mobileUserId != "-1") {
                            ApiService()
                                .postData(
                                    ApiKeys.FAV_SUFFIX,
                                    ApiKeys.getListenLaterQuery(
                                        controller.podcastId.value),
                                    ageNeeded: false)
                                .then((value) => showResponse(context, value));
                          } else {
                            Utility.showRegistrationPromotion(context);
                          }
                        }),
                        listTile('images/report_flag.png', 'Report', () {
                          Get.back();

                          Future.delayed(const Duration(milliseconds: 500), () {
                            showGeneralDialog(
                                context: MainPage.activeContext!,
                                pageBuilder:
                                    (context, animation, secondAnimation) {
                                  return ReportScreen(
                                    id: controller.currentPodcast!.podcastId!,
                                    isPodcast: true,
                                  );
                                });
                          });
                        }),
                        listTile('images/close.png', 'Close Player', () {
                          Get.back();

                          controller.closePlayer();
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  shape: const StadiumBorder(),
                  color: AppColors.firstColor,
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  listTile(String path, String title, VoidCallback callback,
      {addTrail = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: callback,
        child: ListTile(
          leading: ImageIcon(
            AssetImage(path),
            color: AppColors.iconColor,
          ),
          trailing: addTrail
              ? const Text(
                  '+',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              : null,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  showResponse(context, value) {
    ResponseData responseData = ResponseData.fromJson(value);

    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      showSnackBar(context, 'Added');
    } else {
      showSnackBar(context, responseData.response!.toString());
    }
  }

  showSnackBar(context, message, {downloadComplete = false}) {
    if (downloadComplete) controller.downloadProgress.value = 0;

    final SnackBar snackBar = SnackBar(
      content: Text(message),
      backgroundColor: AppColors.firstColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void startDownloadPodcast(context) async {
    controller.downloadInProgress.value = true;

    String podcastId = controller.currentPodcast!.podcastId!;
    String rjUserId = controller.currentPodcast!.userId!;

    final isPodcastExist = await TomTomDb().isPodcastExist(rjUserId, podcastId);
    print(isPodcastExist);
    if (isPodcastExist) {
      AppDialogs.simpleOkDialog(context, 'Already Exist',
          'The podcast already downloaded/exists in your device ');
      controller.downloadInProgress.value = false;
      return;
    }

    String dirPath = await Utility.createFolderInAppDocDir(
        AppConstants.DOWNLOADS_FILES_DIRECTORY);
    String fileName =
        '${controller.currentPodcast!.podcastName!}${p.extension(controller.currentPodcast!.audiopath!)}';
    String fullPath = "$dirPath$fileName";
    /*
    String fullPath =
        "$dirPath${controller.currentPodcast!.podcastName!}${p.extension(controller.currentPodcast!.audiopath!)}";*/
    print(fullPath);

    try {
      final response = await ApiService().dioDownloader.get(
        controller.currentPodcast!.audiopath!,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
            controller.downloadProgress.value =
                int.parse((received / total * 100).toStringAsFixed(0));

            /* if (controller.downloadProgress.value == 100) {
              showSnackBar(context, 'Downloaded', downloadComplete: true);



            }
            */
          } else {
            print("completed!!!");
          }
        },
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      print(response.headers);
      File file = File(fullPath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();

      showSnackBar(context, 'Downloaded', downloadComplete: true);
      insertInToDb(fileName);
      // insertInToDb(fullPath);

    } catch (e) {
      print(e);
      Utility.showSnackBar(context, 'Error');
    }

    controller.downloadInProgress.value = false;
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      controller.downloadProgress.value =
          int.parse((received / total * 100).toStringAsFixed(0));
    } else {
      print("completed!!!");
    }
  }

  Future<void> sharePodcast() async {
    final documentDirectory = (await getTemporaryDirectory()).path;
    String fullPath =
        "$documentDirectory/${controller.currentPodcast!.podcastName!}${p.extension(controller.currentPodcast!.audiopath!)}";

    print(fullPath);

    final response = await ApiService().dioDownloader.get(
          controller.currentPodcast!.audiopath!,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status! < 500;
              }),
        );

    File file = File(fullPath);
    file.writeAsBytesSync(response.data);

    Share.shareFiles([fullPath],
        subject: "TomTom Podcast",
        text: "By " + controller.currentPodcast!.rjname!);
  }

  void insertInToDb(String downloadPath) {
    final podcast = controller.currentPodcast;

    final dbPodcast = DpPodcast(
        podcastId: podcast!.podcastId,
        userId: podcast.userId!,
        rjname: podcast.rjname,
        podcastName: podcast.podcastName,
        authorName: podcast.authorName,
        audiopath: podcast.audiopath,
        imagepath: podcast.imagepath,
        likeCount: podcast.likeCount,
        broadcastDate: podcast.broadcastDate,
        localPath: downloadPath);

    TomTomDb().insertPodcast(dbPodcast);
  }
}
