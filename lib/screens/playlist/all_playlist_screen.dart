import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/controllers/search_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/playlist/collections_list.dart';
import 'package:podcast_app/widgets/list/podcast_list.dart';
import 'package:podcast_app/widgets/menus_title.dart';

class AllPlayListScreen extends GetView<PlayListController> {
  const AllPlayListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchCollections();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() => controller.collections.value.isNotEmpty
              ? const MenusTitle(text: 'By Folder')
              : const SizedBox.shrink()),
          const CollectionsList(),
          Obx(() => controller.podcasts.value.isNotEmpty
              ? MenusTitle(
                  text: 'By List - ${controller.selectedCollectionName.value}',
                )
              : const SizedBox.shrink()),
          Obx(() => controller.podcasts.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MaterialButton(
                    onPressed: () {
                      gotoSearch();
                    },
                    color: AppColors.firstColor.withOpacity(0.2),
                    minWidth: double.infinity,
                    height: 60,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Text(
                      '+ Add Podcast to collection',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          Obx(
            () => controller.podcasts.value.isNotEmpty
                ? PodcastList(
                    podcasts: controller.podcasts.value,
                    shrinkWrap: true,
                    longCallback: (id) {
                      //controller.deletePodcastItem(context, podcast.podcastId!);

                      deletePodcast(context, id);
                      controller.deletePodcastItem(context, id);
                    },
                  )
                : const SizedBox.shrink(),
          ),
          const SizedBox(
            height: 150,
          ),

          /*Obx(
            () => controller.selectedCollectionId.value.isNotEmpty
                ? FutureBuilder(
                    builder: (context, snapShot) {
                      if (snapShot.hasData) {
                        try {
                          PodcastResponse response =
                              PodcastResponse.fromJson(snapShot.data as dynamic);

                          if (response.status == "Error" ||
                              response.podcasts == null) {
                            return const NoDataWidget();
                          }

                          List<Podcast> podcasts = response.podcasts!;

                          return podcasts.isNotEmpty
                              ? PodcastList(
                                podcasts: podcasts,shrinkWrap: true,
                              )
                              : const NoDataWidget();
                        } catch (e) {
                          return const NoDataWidget();
                        }

                        // return updateTilesData(snapShot.data, categoryName!);
                      } else if (snapShot.hasError) {
                        return const Text(
                          'No Data',
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
                      ApiKeys.PODCASTS_LIST_BY_COLLECTION_SUFFIX,
                      ApiKeys.getPodcastsByCollectionIdQuery(
                          controller.selectedCollectionId.value),
                    ),
                    // future: ApiService().fetchRjs(apiSuffix, query ?? {}),
                    // future: ApiService().fetchTrendingPodcasts(),
                  )
                : const SizedBox.shrink(),
          ),*/
          SizedBox(
            height: Get.find<MainController>().panelController.isPanelOpen
                ? 150
                : 100,
          )
        ],
      ),
    );
  }

  void deletePodcast(BuildContext context, String folder_file_id) async {
    AppDialogs.simpleSelectionDialog(context, "Confirmation?",
            "Would you like to remove this podcast from  collection?", "Remove")
        .then((value) {
      if (value == AppConstants.OK) {
        ApiService()
            .deleteData(ApiKeys.DELETE_PODCAST_FROM_COLLECTION_SUFFIX,
                ApiKeys.deletePodcastQuery(folder_file_id))
            .then((value) {
          //hide success dialog
          //updateResponse(context, value);
          controller.fetchPodcastByCollectionId();
        });
      }
    });
  }

  void updateResponse(BuildContext context, response) {
    ResponseData responseData = ResponseData.fromJson(response);
    print('all_playlistscreen.................................$responseData');
    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      AppDialogs.simpleOkDialog(context, 'Success',
              "Successfully removed the podcast from the collection.")
          .then((value) {
        controller.fetchPodcastByCollectionId();
      });
    } else {
      AppDialogs.simpleOkDialog(context, 'Failed',
          responseData.response ?? "unable to process request");
    }
  }

  void gotoSearch() {
    Get.find<SearchController>().enablePlaylistSearch();
  }
}
