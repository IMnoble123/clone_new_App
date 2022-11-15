import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/db/db.dart';
import 'package:podcast_app/db/db_podcast.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/dynamic_links_service.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/login/login_screen.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/screens/sub_screens/add_collections_screen.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:share_plus/share_plus.dart';

import 'package:path/path.dart' as p;

class TopicDescriptionScreen extends GetView<MainController> {
  final Podcast? podcast;
  final VoidCallback? playAll;

  const TopicDescriptionScreen( {Key? key, this.podcast,this.playAll}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      'images/description_file.png',
                      width: 50,
                      height: 50,
                    ),
                    const Text(
                      '\nDescription of Topic',
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              podcast!.description!.isNotEmpty
                                  ? podcast!.description!
                                  : '',
                              style: const TextStyle(
                                  color: AppColors.textSecondaryColor, fontSize: 14),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Podcaster : ${podcast!.rjname!.isNotEmpty ? podcast!.rjname! : ''}',
                            style: const TextStyle(
                                color: AppColors.textSecondaryColor,
                                fontSize: 12),
                          ),
                          Text(
                            'Date : ${podcast!.broadcastDate!.isNotEmpty
                                ? Utility.getRequiredDateFormat(podcast!.broadcastDate!)
                                : ''} ',
                            style: const TextStyle(
                                color: AppColors.textSecondaryColor,
                                fontSize: 12),
                          ),
                         /* Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  podcast!.broadcastDate!.isNotEmpty
                                      ? podcast!.broadcastDate!
                                      : '',
                                  style: const TextStyle(
                                      color: AppColors.textSecondaryColor,
                                      fontSize: 12),
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  '0 Episodes',
                                  style: TextStyle(
                                      color: AppColors.textSecondaryColor,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Total Duration  00:20:10 ',
                                  style: TextStyle(
                                      color: AppColors.textSecondaryColor,
                                      fontSize: 12),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Podcaster : ${podcast!.rjname!.isNotEmpty ? podcast!.rjname! : ''}',
                                  style: const TextStyle(
                                      color: AppColors.textSecondaryColor,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),*/
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            color: AppColors.disableColor,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        itemExtent: 50,
                        children: [
                          /*listTile('images/play_all.png', 'Play all Episodes', () {


                            if(playAll!=null){
                              playAll!();
                              Get.back();
                            }

                          }),

                          listTile('images/forward.png', 'Play Next podcast', () {
                            print('next podcast');
                            Get.find<MainController>().nextPodcast();
                            Get.back();
                          }),*/
                          Stack(
                            children: [
                              listTile('images/download_icon.png', 'Download', () {



                                if (CommonNetworkApi().mobileUserId != "-1") {

                                  if(!controller.downloadInProgress.value){
                                    controller.downloadProgress.value = 0;
                                    startDownloadPodcast(context);
                                  }


                                } else {
                                  Utility.showRegistrationPromotion(context);
                                }


                              }),
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Obx(
                                  () => controller.downloadProgress.value != 0 &&
                                          controller.downloadProgress.value != 100
                                      ? Center(
                                          child: SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: CircularProgressIndicator(
                                              backgroundColor: AppColors.firstColor
                                                  .withOpacity(0.4),
                                              value:
                                                  controller.downloadProgress.value /
                                                      100,
                                              color: AppColors.firstColor,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              )
                            ],
                          ),
                          /*listTile('images/download_icon.png', 'Download', () {

                            controller.downloadProgress.value = 0;
                            startDownloadPodcast(context);

                          }),*/
                          listTile('images/share_circle.png', 'Share', () {
                            //sharePodcast();



                            if (CommonNetworkApi().mobileUserId != "-1") {
                              DynamicLinksService.createDynamicLink(
                                  podcast!)
                                  .then((value) {
                                print(value);
                                Share.share(value);
                                // Share.share(HtmlWidget(dummy).html);
                              });
                            } else {
                              Utility.showRegistrationPromotion(context);
                            }


                          }),
                          /*listTile('images/like.png', 'like', () {

                            if (CommonNetworkApi().mobileUserId != "-1") {

                              ApiService()
                                  .postData(ApiKeys.LIKE_DIS_LIKE_HEART_SUFFIX,
                                  ApiKeys.getLdhQuery(podcast!.podcastId!, 'like'))
                                  .then((value) => showResponse(context, value));

                            } else {
                              Utility.showRegistrationPromotion(context);
                            }



                          }),*/
                          listTile('images/add_play_list.png', 'add to play list',
                              () {
                            if (CommonNetworkApi().mobileUserId != "-1") {
                              showGeneralDialog(
                                  context: context,
                                  pageBuilder: (context, animation, secondAnimation) {
                                    return AddPlayListCollectionScreen(
                                        podcast!.podcastId!);
                                  });
                            } else {
                              Utility.showRegistrationPromotion(context);
                            }
                          }, addTrail: true),
                          listTile('images/timer.png', 'Listen later', () {


                            if (CommonNetworkApi().mobileUserId != "-1") {
                              ApiService()
                                  .postData(ApiKeys.FAV_SUFFIX,
                                  ApiKeys.getListenLaterQuery(podcast!.podcastId!),ageNeeded: false)
                                  .then((value) => showResponse(context, value));
                            } else {
                              Utility.showRegistrationPromotion(context);
                            }


                          }),



                        ],
                      ),
                    ),


                  ],
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
            ),
            const SizedBox(
              height: 10,
            ),
          ],
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
      Utility.showSnackBar(context, 'Added');
    } else {
      Utility.showSnackBar(context, responseData.response!.toString());
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

  Future<void> sharePodcast() async {
    final documentDirectory = (await getTemporaryDirectory()).path;
    String fullPath =
        "$documentDirectory/${podcast!.podcastName!}${p.extension(podcast!.audiopath!)}";

    print(fullPath);

    final response = await ApiService().dioDownloader.get(
          podcast!.audiopath!,
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
        subject: "TomTom Podcast", text: "By " + podcast!.rjname!);
  }

  void startDownloadPodcast(context) async {



    String podcastId = podcast!.podcastId!;
    String rjUserId = podcast!.userId!;

    controller.downloadInProgress.value = true;

    final isPodcastExist = await TomTomDb().isPodcastExist(rjUserId, podcastId);

    if(isPodcastExist){

      AppDialogs.simpleOkDialog(context, 'Already Exist', 'The podcast already downloaded/exists in your device ');
      controller.downloadInProgress.value = false;
      return;
    }


    String dirPath = await Utility.createFolderInAppDocDir(
        AppConstants.DOWNLOADS_FILES_DIRECTORY);
    String fileName = '${podcast!.podcastName!}${p.extension(podcast!.audiopath!)}';
    String fullPath =
        "$dirPath$fileName";
        // "$dirPath${podcast!.podcastName!}${p.extension(podcast!.audiopath!)}";
    print(fullPath);

    try {
      final response = await ApiService().dioDownloader.get(
        podcast!.audiopath!,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + "%");
            controller.downloadProgress.value =
                int.parse((received / total * 100).toStringAsFixed(0));

            /*if (controller.downloadProgress.value == 100) {
              showSnackBar(context, 'Downloaded', downloadComplete: true);

            }*/
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
      controller.downloadProgress.value = 0;
      Utility.showSnackBar(context, 'Error');
    }

    controller.downloadInProgress.value = false;

  }

  void insertInToDb(String downloadPath) {
    final dbPodcast = DpPodcast(
        podcastId: podcast!.podcastId,
        userId: podcast!.userId!,
        rjname: podcast!.rjname,
        podcastName: podcast!.podcastName,
        authorName: podcast!.authorName,
        audiopath: podcast!.audiopath,
        imagepath: podcast!.imagepath,
        likeCount: podcast!.likeCount,
        broadcastDate: podcast!.broadcastDate,
        localPath: downloadPath);

    print(podcast!.rjname);

    TomTomDb().insertPodcast(dbPodcast).then((value) => print(value));
  }
}
