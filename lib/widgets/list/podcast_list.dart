import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:podcast_app/widgets/song_info_tile.dart';

import '../../controllers/main_controller.dart';
import '../../models/response/podcast_response.dart';
import '../../network/common_network_calls.dart';

typedef StringToVoidFunc = void Function(String);

class PodcastList extends StatelessWidget {
  final List<Podcast> podcasts;
  final bool shrinkWrap;
  final StringToVoidFunc? longCallback;
  final bool needPodId;

  const PodcastList(
      {Key? key,
      required this.podcasts,
      this.shrinkWrap = false,
      this.longCallback,
      this.needPodId = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlidableAutoCloseBehavior(
      closeWhenTapped: true,
      child: ListView.separated(
          itemBuilder: (c, i) {
            return Slidable(
              key: ValueKey(i),
              enabled: longCallback!=null,

              closeOnScroll: true,

              endActionPane: ActionPane(
                motion: const StretchMotion(),
                /*dismissible: DismissiblePane(onDismissed: () {

                  if (needPodId) {
                    longCallback!(podcasts[i].podcastId!);
                  } else {
                    longCallback!(podcasts[i].folderFileId!);
                  }

                }),*/
                openThreshold: 0.1,
                closeThreshold: 0.4,
                extentRatio: 0.25,

                children: [
                  SlidableAction(
                    onPressed: (c) {

                      if (needPodId) {
                        longCallback!(podcasts[i].podcastId!);
                      } else {
                        longCallback!(podcasts[i].folderFileId!);
                      }

                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),

              child: SongInfoTile(
                podcast: podcasts[i],
                callback: () {
                  Get.find<MainController>()
                      .tomtomPlayer
                      .addAllPodcasts(podcasts, i);

                  CommonNetworkApi().postViewed(podcasts[i].podcastId!);
                },
                longCallback: () {
                 /* if (needPodId) {
                    longCallback!(podcasts[i].podcastId!);
                  } else {
                    longCallback!(podcasts[i].folderFileId!);
                  }*/
                  // longCallback!(podcasts[i].podcastId!);
                },
                playAll: (){
                  Get.find<MainController>()
                      .tomtomPlayer
                      .addAllPodcasts(podcasts, 0);
                },
              ),
            );
          },
          separatorBuilder: (c, i) {
            return const Divider();
          },
          shrinkWrap: shrinkWrap,
          primary: !shrinkWrap,
          itemCount: podcasts.length),
    );
  }
}
