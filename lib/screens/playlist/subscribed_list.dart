import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/subscibed_response_data.dart';
import 'package:podcast_app/widgets/list/podcast_list.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

class SubscribedPodcasts extends GetView<PlayListController> {
  const SubscribedPodcasts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchSubscribedList();
    return SingleChildScrollView(
      child: controller.mainRjList.value.isNotEmpty?Column(
        children: [
          Obx(() =>
              SizedBox(
                  height: 150,
                  child: controller.mainRjList.value.isNotEmpty
                      ? updateRjsData(context, controller.mainRjList.value)
                      : const NoDataWidget())),
          Obx(
                () => controller.showingPodcasts.value.isNotEmpty
                ? PodcastList(
              podcasts: controller.showingPodcasts.value, shrinkWrap: true,)
                : const SizedBox.shrink()
            ,
          ),
          const SizedBox(height: 150,)
        ],
      ):SizedBox(
        height: MediaQuery.of(context).size.height/2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.notifications_active, size: 50,
              color: Colors.white,
            ),
            Text(
              'Oh oh ! You have no subscriptions.',
              style: TextStyle(color: Colors.white,fontSize: 14), textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'We don\'t charge for subscriptions like the OTT\'s do. Never miss a podcast from your favourite podcasters by subscribing.',
                style: TextStyle(color: Colors.white,fontSize: 14), textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  updateRjsData(BuildContext context, List<RjList> items) {
    return ListView.separated(
      itemBuilder: (c, i) {
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
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: items[i].profileImage ??
                                  AppConstants.dummyPic,
                              width: 100,
                              height: 100,memCacheWidth: 100,memCacheHeight: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                              const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                              Container(width:100,height: 100,color:AppColors.firstColor.withOpacity(0.25),child: const Icon(Icons.error_outline,color: Colors.white,size: 25,)),
                            )),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        items[i].rjName!,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style:
                        const TextStyle(color: Colors.white, fontSize: 14),
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
                        controller.selectedRjId.value = items[i].rjUserId!;

                        controller.filterPodcastsByRjId();
                      },
                    ),
                  )),
            ],
          ),
        );
      },
      separatorBuilder: (c, i) {
        return const SizedBox(
          width: 2,
        );
      },
      itemCount: items.length,
      scrollDirection: Axis.horizontal,
    );
  }
}
