import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/db/db.dart';
import 'package:podcast_app/db/db_podcast.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/download_song_info_tile.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

class DownloadedScreen extends GetView<PlayListController> {
  final String? title;

  const DownloadedScreen({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchDownloads();
    return SingleChildScrollView(
        child: controller.dpPodcasts.isNotEmpty?Column(
          children: [
            /*FutureBuilder(
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  return updatePodcast(snapShot.data);
                } else if (snapShot.hasError) {
                  return const NoDataWidget();
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                  ));
                }
              },
              future: fetchDownloadedPodcasts(),
              // future: fetchDownloadedFile(),
            ),*/
            Obx(() => controller.dpPodcasts.value.isNotEmpty
                ? updatePodcast(controller.dpPodcasts.value)
                : const NoDataWidget()),
            const SizedBox(
              height: 150,
            ),
          ],
        ):SizedBox(
          height: MediaQuery.of(context).size.height/2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.download_rounded, size: 50,
                color: Colors.white,
              ),
              Text(
                'No downloaded episodes.',
                style: TextStyle(color: Colors.white,fontSize: 14), textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Tap the download option on any episode to listen offline at your convenience.',
                  style: TextStyle(color: Colors.white,fontSize: 14), textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),

    );
  }

  fetchDownloadedFile() async {
    String dirPath = await Utility.createFolderInAppDocDir(
        AppConstants.DOWNLOADS_FILES_DIRECTORY);
    List files = Directory(dirPath).listSync();

    print(files.length);

    return files;
  }

  fetchDownloadedPodcasts() async {
    final result = await TomTomDb().dpPodcasts();

    print(result.length);

    return result;
  }

  Widget updatePodcast(dynamic data) {
    List<DpPodcast> dpPodcasts = data as List<DpPodcast>;

    //return ListView.builder(itemBuilder: (c,i){return downloadItem(files[i]);},itemCount: files.length,);

    return SlidableAutoCloseBehavior(
      closeWhenTapped: true,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(index),
            closeOnScroll: true,
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              /*dismissible: DismissiblePane(onDismissed: () {
                TomTomDb()
                    .deletePodcast(dpPodcasts[index].podcastId!)
                    .then((value) => controller.fetchDownloads());

                Utility.showSnackBar(context, 'Deleted');

              }),*/
              openThreshold: 0.1,
              closeThreshold: 0.4,
              extentRatio: 0.25,
              children: [
                SlidableAction(
                  onPressed: (c) {
                    AppDialogs.simpleSelectionDialog(
                            context,
                            "Confirmation?",
                            "Would you like to remove this podcast from  Downloads?",
                            "Remove")
                        .then((value) {
                      if (value == AppConstants.OK) {
                        TomTomDb()
                            .deletePodcast(dpPodcasts[index].podcastId!)
                            .then((value) => controller.fetchDownloads());
                      }
                    });
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: DownloadedSongInfoTile(
              podcast: dpPodcasts[index],
              callback: () {
                Get.find<MainController>()
                    .tomtomPlayer
                    .addAllDownloadedPodcasts(dpPodcasts, index);
                Get.find<MainController>().togglePanel();

                CommonNetworkApi().postViewed(dpPodcasts[index].podcastId!);
              },
              longCallback: () {
                /*AppDialogs.simpleSelectionDialog(
                        context,
                        "Confirmation?",
                        "Would you like to remove this podcast from  Downloads?",
                        "Remove")
                    .then((value) {
                  if (value == AppConstants.OK) {
                    TomTomDb()
                        .deletePodcast(dpPodcasts[index].podcastId!)
                        .then((value) => controller.fetchDownloads());
                  }
                });*/
              },
            ),
          );
        },
        itemCount: dpPodcasts.length,
        shrinkWrap: true,
        primary: false,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
      ),
    );
  }

/*Widget updatePodcast(dynamic data) {
    List<FileSystemEntity> files = data as List<FileSystemEntity>;

    //return ListView.builder(itemBuilder: (c,i){return downloadItem(files[i]);},itemCount: files.length,);

    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3 / 4,
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                SizedBox(
                  width: 100,
                  //height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset('images/download_pic.webp',
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              )),
                          CircleAvatar(
                            backgroundColor:
                            AppColors.firstColor.withOpacity(0.5),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          )
                        ],
                        alignment: Alignment.center,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          basename(files[index].path),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),

                    ],
                  ),
                ),
                Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {

                        },
                      ),
                    )),
              ],
            ),
          );
        },
        itemCount: files.length);
  }*/

}
