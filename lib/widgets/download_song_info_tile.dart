import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/db/db_podcast.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/sub_screens/topic_description_screen.dart';

class DownloadedSongInfoTile extends StatelessWidget {
  final DpPodcast? podcast;
  final VoidCallback callback;
  final VoidCallback? longCallback;

  const DownloadedSongInfoTile(
      {Key? key, this.podcast, required this.callback, this.longCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(8.0))),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 10,
              ),
              Stack(alignment: Alignment.center, children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: podcast!.imagepath!.isNotEmpty &&
                              !podcast!.imagepath!.contains(".jfif")
                          ? podcast!.imagepath!
                          : AppConstants.dummyPic,
                      width: 75,
                      height: 75, memCacheWidth: 75,memCacheHeight: 75,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset(
                        'images/download_pic.webp',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    )),
                CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.5),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    size: 30,
                  ),
                )
              ]),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        podcast!.podcastName ?? '',
                        maxLines: 3,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'By ${podcast!.rjname ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: AppColors.disableColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              /*Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        podcast!.podcastName ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'By ${podcast!.rjname ?? ''}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: AppColors.disableColor,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${podcast!.broadcastDate}',
                          //'28 Feb 2022 - 30 Episodes',
                          style: const TextStyle(
                            color: AppColors.disableColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
            ],
          ),
          Positioned.fill(

              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    //Get.find<MainController>().togglePanel();

                    FocusScope.of(context).unfocus();
                    checkMusicStrop();

                    //Get.find<MainController>().updatePodcast(podcast!);

                    callback();

                    CommonNetworkApi().postViewed(podcast!.podcastId!);
                  },
                  onLongPress: longCallback != null ? longCallback! : () {},
                ),
              ))
        ],
      ),
    );
  }

  void checkMusicStrop() async {
    if (!Get.find<MainController>().panelController.isPanelShown) {
      await Get.find<MainController>().panelController.show();
    }
  }
}
