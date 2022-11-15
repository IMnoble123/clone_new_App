import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/list/podcast_list.dart';

class FavoriteList extends GetView<PlayListController> {
  final String? title;
  final String apiSuffix;
  final Map<String, dynamic>? query;

  const FavoriteList(
      {Key? key, this.title, required this.apiSuffix, this.query})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    

    controller.fetchFavourites(apiSuffix, query ?? {});

    /*if (title!.contains('Favorite')) {
      controller.fetchFavourites(apiSuffix, query ?? {});
    } else if (title!.contains('Listen Later')) {
      controller.fetchListenLater(apiSuffix, query ?? {});
    } else if (title!.contains('History')) {
      controller.fetchHistory(apiSuffix, query ?? {});
    }*/

    return SingleChildScrollView(
      child: Obx(
          ()=> controller.favList.value.isNotEmpty?Column(
          children: [
           /* Obx(() => controller.favList.value.isNotEmpty
                ? showList(context, controller.favList.value)
                : const NoDataWidget()),*/
            showList(context, controller.favList.value),
            /*FutureBuilder(
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  try {
                    PodcastResponse response =
                        PodcastResponse.fromJson(snapShot.data as dynamic);

                    if (response.status == "Error" || response.podcasts == null) {
                      return const NoDataWidget();
                    }

                    List<Podcast> podcasts = response.podcasts!;

                    return podcasts.isNotEmpty
                        ? PodcastList(
                            podcasts: podcasts,
                            shrinkWrap: true,
                            needPodId: true,
                            longCallback: title!.contains('History')
                                ? (id) {}
                                : (podcastId) {
                                    unFavoritePodcast(context, podcastId);
                                  },
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
              future: ApiService().fetchRjs(apiSuffix, query ?? {}),
              // future: ApiService().fetchTrendingPodcasts(),
            ),*/
            const SizedBox(
              height: 150,
            )
          ],
        ):SizedBox(
          height: MediaQuery.of(context).size.height/2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [

         /* Text(
            'No downloaded episodes.',
            style: TextStyle(color: Colors.white,fontSize: 14), textAlign: TextAlign.center,
          ),*/

          if(title!.contains('Favourite'))
            SizedBox(
              height: MediaQuery.of(context).size.height/2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.star_border_rounded, size: 50,
                    color: Colors.white,
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'Oops, Your favourite list is currently empty.\nFind more of the podcasts \nyou may love from the Home.',
                        style: TextStyle(color: Colors.white,fontSize: 14), textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            )

          else if(title!.contains('Listen Later'))
            SizedBox(
              height: MediaQuery.of(context).size.height/2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:  [
                  Stack(
                    alignment: Alignment.center,
                    children: [

                      Transform.translate(
                        offset:const Offset(0,-3),
                        child: const Icon(
                          Icons.replay, size: 55,
                          color: Colors.white,
                        ),
                      ),const Icon(
                        Icons.play_arrow_rounded, size: 20,
                        color: Colors.white,
                      ),

                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'You might be busy at the moment. Use the \'Listen later\' option to listen to that podcast episode whenever your ears are free.',
                        style: TextStyle(color: Colors.white,fontSize: 14), textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            )

          else if(title!.contains('History'))
            SizedBox(
              height: MediaQuery.of(context).size.height/2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.history, size: 50,
                    color: Colors.white,
                  ),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'No podcasts in progress',
                        style: TextStyle(color: Colors.white,fontSize: 14), textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            )



        ],
      ),
    ),
      ),
    );
  }

  void unFavoritePodcast(BuildContext context, String podcastId) async {
    AppDialogs.simpleSelectionDialog(context, "Confirmation?",
            "Would you like to remove this podcast from  ${title}?", "Remove")
        .then((value) {
      if (value == AppConstants.OK) {
        ApiService()
            .deleteData(
                ApiKeys.FAV_SUFFIX,
                title!.contains('Favourite')
                    ? ApiKeys.getFavouriteQuery(podcastId)
                    : ApiKeys.getListenLaterQuery(podcastId))
            .then((value) {
              //hide success dialog
          //updateResponse(context, value);
          controller.fetchFavourites(apiSuffix, query ?? {});
        });
        ;
      }
    });
  }

  void updateResponse(BuildContext context, response) {
    ResponseData responseData = ResponseData.fromJson(response);
    print(responseData);
    print('-----');
    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      AppDialogs.simpleOkDialog(context, 'Success',
              "Successfully removed the podcast from the ${title}.")
          .then((value) {
        // controller.fetchPodcastByCollectionId();

        controller.fetchFavourites(apiSuffix, query ?? {});

      });
    } else {
      AppDialogs.simpleOkDialog(context, 'Failed',
          responseData.response ?? "unable to process request");
    }
  }

  showList(BuildContext context, List<Podcast> podcasts) {
    print(podcasts.length);
    return PodcastList(
      podcasts: podcasts,
      shrinkWrap: true,
      needPodId: true,
      longCallback: title!.contains('History')
          // ? (id) {}
          ? null
          : (podcastId) {
              unFavoritePodcast(context, podcastId);
            },
    );
  }
}
