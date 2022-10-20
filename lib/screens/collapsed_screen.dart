import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/screens/sub_screens/podcast_more_options_screen.dart';
import 'package:podcast_app/widgets/stroke_circular_btn.dart';

class CollapsedScreen extends GetView<MainController> {
  const CollapsedScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DateTime? currentBackPressTime;
    return InkWell(
      splashColor: Colors.red,
      onTap: () {
        print('cliced');
        controller.togglePanel();
      },
      child: Container(
        color: Colors.black,
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => CachedNetworkImage(
                  imageUrl: controller.coverPic.value.isNotEmpty
                      ? controller.coverPic.value
                      : AppConstants.dummyPic,
                  imageBuilder: (context, imageProvider) => Container(
                    height: kToolbarHeight-20,
                    width: kToolbarHeight-20,

                    decoration: BoxDecoration(
                     // borderRadius: const BorderRadius.all(Radius.circular(100)),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )),
            /* Obx(
              () => CircleAvatar(
                radius: 20.0,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(controller.coverPic.value.isEmpty
                    ? AppConstants.dummyPic
                    : controller.coverPic.value),
              ),
            ),*/
            /*const CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(
                  'https://qqcdnpictest.mxplay.com/pic/8bd21b4e7f4fae507246e2f77e631fee/en/2x3/320x480/test_pic1635764009166.webp'),
            ),*/
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Obx(
                          () => Text(
                            controller.podcastName.value.isEmpty
                                ? ''
                                : controller.podcastName.value,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Obx(
                          () => Text(
                            'By ${controller.podcastBy.value.isEmpty ? 'Rj' : controller.podcastBy.value} ',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Obx(
              () => StrokeCircularButton(
                callback: () {
                  //controller.updateSeekPosition(0.0);
                  //controller.previousPodcast();

                  DateTime now = DateTime.now();

                  if (currentBackPressTime == null ||
                      now.difference(currentBackPressTime!) >
                          const Duration(seconds: 3)) {
                    currentBackPressTime = now;

                    controller.updateSeekPosition(0.0);
                  } else {
                    controller.previousPodcast();
                  }
                },
                disable: controller.isFirstPodcast.value,
                strokeWidth: 2.0,
                iconData: Icons.skip_previous,
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            /*Obx(
              () => StrokeCircularButton(
                callback: () {
                  controller.updatePlayingState(!controller.isPlaying.value);
                },
                strokeWidth: 2.0,
                iconData: controller.isPlaying.value
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
                bgColor: Colors.red,
              ),
            ),*/
            Obx(
              () => controller.isLoadingPodcast.value
                  ? const Center(
                      child: SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator()),
                    )
                  : StrokeCircularButton(
                      iconData: controller.isPlaying.value
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      callback: () {
                        /* controller.updatePlayingState(
                      !controller.isPlaying.value);*/

                        if (controller.isPlaying.value) {
                          controller.pausePodcast();
                        } else {
                          controller.playPodcast();
                        }
                      },
                      strokeWidth: 2,
                      iconSize: 25,
                      bgColor: AppColors.firstColor,
                    ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Obx(
              () => StrokeCircularButton(
                callback: () {
                  controller.nextPodcast();
                },
                strokeWidth: 2.0,
                disable: controller.isLastPodcast.value,
                iconData: Icons.skip_next,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: IconButton(
                  onPressed: () {
                    //Get.to(const PodcastMoreOptionsScreen());

                    showGeneralDialog(
                        context: context,
                        pageBuilder: (context, animation, secondAnimation) {
                          return const PodcastMoreOptionsScreen();
                        });
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
