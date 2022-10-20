import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/controllers/search_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/models/response/search_response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/btns/stadium_buttons.dart';


class PlayListSearchScreen extends GetView<SearchController> {
  const PlayListSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Theme(
        data: ThemeData(
            unselectedWidgetColor: AppColors.disableColor,
            toggleableActiveColor: AppColors.firstColor),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 54, 0, 0), Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5])),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(() => controller.searchText.isEmpty
                        ? const SizedBox(
                            height: 300,
                            child: Center(
                                child: Text(
                              'Search by Podcasts.',
                              style: TextStyle(color: Colors.white),
                            )))
                        : const SizedBox.shrink()),
                    Obx(
                      () => controller.searchText.value.isNotEmpty
                          ? FutureBuilder(
                              builder: (context, snapShot) {
                                if (snapShot.hasData) {
                                  return displaySearchResults(snapShot.data);
                                } else if (snapShot.hasError) {
                                  return const Text(
                                    'No Results',
                                    style: TextStyle(color: Colors.white),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 3.0,
                                  ));
                                }
                              },
                              future: ApiService().postData(
                                  ApiKeys.SEARCH_NEW_SUFFIX,
                                  getQuery(controller.searchText.value)),
                              // future: ApiService().fetchSearchResults(getQuery(controller.searchText.value)),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: Platform.isIOS?50:0,
                left: 0,
                right: 0,
                child: Container(
                  padding:  EdgeInsets.only(left: 10, right: 10, bottom: Get.find<MainController>().panelController.isPanelShown?100:40),
                  // padding:  EdgeInsets.only(left: 10, right: 10, bottom: Get.find<MainController>().panelController.isPanelShown?150:90),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          'selected  ${controller.selectedPodCasts.length}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      StadiumButton(
                        title: 'Add to collection',
                        callback: () {
                          if (controller.selectedPodCasts.isNotEmpty) {
                            addToPlaylist(context);
                          }else{
                            controller.dismissPlaylistSearch();
                          }
                        },
                        bgColor: AppColors.firstColor,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget displaySearchResults(dynamic data) {
    print(data);

    try {
      SearchResponseData response = SearchResponseData.fromJson(data);

      if (response.status == "Error") {
        return Container(
          alignment: Alignment.center,
          child: const Text(
            'No Results',
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      List<Podcast> searchPodcasts = response.response!.podcastList!;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return SelectablePodcast(podcast: searchPodcasts[index]);
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: searchPodcasts.length),
             SizedBox(
              height: Get.find<MainController>().panelController.isPanelShown?200:150,
            )
          ],
        ),
      );
    } catch (e) {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'No Results',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  void addToPlaylist(BuildContext context) async {

    String folderId = Get.find<PlayListController>().selectedCollectionId.value;

    final response = await ApiService().postData(
        ApiKeys.ADD_PODCAST_TO_COLLECTION_SUFFIX,
        ApiKeys.getAddPodcastToCollectionQuery(controller.selectedPodCasts.value, folderId));
    // Get.find<MainController>().currentPodcast!.podcastId!, folderId));

    ResponseData responseData = ResponseData.fromJson(response);

    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      Utility.showSnackBar(context, 'Added');
    } else {
      Utility.showSnackBar(context, responseData.response ?? "Failed");
    }

    Get.find<PlayListController>().fetchPodcastByCollectionId();
    controller.dismissPlaylistSearch();
  }
}

Map<String, dynamic> getQuery(String value) {
  return {"keyword": value};
}

class SelectablePodcast extends StatefulWidget {
  final Podcast? podcast;

  const SelectablePodcast({Key? key, this.podcast}) : super(key: key);

  @override
  State<SelectablePodcast> createState() => _SelectablePodcastState();
}

class _SelectablePodcastState extends State<SelectablePodcast> {
  String defaultValue = '';

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
            children: [
              const SizedBox(
                width: 10,
              ),
              Stack(alignment: Alignment.center, children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.podcast!.imagepath!.isNotEmpty &&
                              !widget.podcast!.imagepath!.contains(".jfif")
                          ? widget.podcast!.imagepath!
                          : AppConstants.dummyPic,
                      width: 75,
                      height: 75,memCacheWidth: 75,memCacheHeight: 75,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                      widget.podcast!.podcastName ?? '',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'By ${widget.podcast!.rjname ?? ''}',
                      style: const TextStyle(
                        color: AppColors.disableColor,
                      ),
                    ),
                  ],
                ),
              )),
              /*Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            widget.podcast!.podcastName ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            ' By ${widget.podcast!.rjname ?? ''}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.disableColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${widget.podcast!.broadcastDate}',
                        //'28 Feb 2022 - 30 Episodes',
                        style: const TextStyle(
                          color: AppColors.disableColor,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${widget.podcast!.commentCount} Comments',
                        style: const TextStyle(
                          color: AppColors.disableColor,
                        ),
                      ),
                    )
                  ],
                ),
              )),*/
              Transform.scale(
                scale: 1.25,
                child: Radio(
                  value: widget.podcast!.podcastId!,
                  toggleable: true,
                  groupValue: defaultValue,
                  onChanged: (value) {
                    setState(() {
                      //widget.podcast!.isSelected = !(widget.podcast!.isSelected??false);
                      print(value);
                      if (value == widget.podcast!.podcastId!) {
                        defaultValue = value as String;
                        widget.podcast!.isSelected = true;
                        Get.find<SearchController>()
                            .selectedPodCasts
                            .add(widget.podcast!.podcastId!);
                      } else {
                        defaultValue = "";
                        widget.podcast!.isSelected = false;
                        Get.find<SearchController>()
                            .selectedPodCasts
                            .remove(widget.podcast!.podcastId!);
                      }
                    });
                  },
                ),
              ),
              /* Checkbox( shape: const CircleBorder(), value: widget.podcast!.isSelected??false, onChanged: (b) {

                setState(() {
                  widget.podcast!.isSelected = !(widget.podcast!.isSelected??false);
                });

              }),*/
            ],
          ),
        ],
      ),
    );
  }
}
