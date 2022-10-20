import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/widgets/header.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';
import '../main/main_page.dart';

class PodcastListHorizontal extends StatelessWidget {
  final String? headerTitle;
  final String apiSuffix;
  final Map<String, dynamic>? query;
  final bool isPodcast;
  final VoidCallback? callback;
  final String? filter;

  const PodcastListHorizontal(
      {Key? key,
      this.headerTitle,
      required this.apiSuffix,
      this.isPodcast = true,
      this.query,
      this.callback,
      this.filter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Podcast> podcastList = [];

    var cardWidth = MediaQuery.of(MainPage.activeContext!).size.width/2-3*15;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          HeaderSection(
            title: headerTitle ?? '',
            callback: () {
              /*final args = ScreenArguments(headerTitle ?? '', '', podcastList);
              Navigator.pushNamed(context, AppRoutes.podcastListScreen,
                  arguments: args);*/
              if (callback != null) callback!();
            },
          ),
          SizedBox(
            height: cardWidth+50,
            child: FutureBuilder(
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
                    if (filter != null) {
                      podcastList = podcasts
                          .where(
                              (element) => element.category!.contains(filter!))
                          .toList();
                    } else {
                      podcastList = podcasts;
                    }

                    return updateTilesData(podcastList,cardWidth);
                  } catch (e) {
                    return const NoDataWidget();
                  }

                  // return updateTilesData(snapShot.data, categoryName!);
                } else if (snapShot.hasError) {
                  return const Text(
                    'Error',
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  return const Center(
                      child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                  ));
                }
              },
              future: ApiService().postData(apiSuffix, query ?? {}),
              // future: ApiService().fetchRjs(apiSuffix, query ?? {}),
              // future: ApiService().fetchTrendingPodcasts(),
            ),
          ),
        ],
      ),
    );
  }

  Widget updateTilesData(List<Podcast> podcasts,cardWidth) {



    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          print(podcasts[index].imagepath!);
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                SizedBox(
                  width: cardWidth,
                  //height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          /*ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                //"https://d3e11wjvplotyb.cloudfront.net/1654530154_Conqueryourself-01.jpg",
                                //podcasts[index].imagepath!,
                                // "https://d3e11wjvplotyb.cloudfront.net/1654773329_Conqueryoursel_compressed.jpg",
                                //"https://d3e11wjvplotyb.cloudfront.net/1654773329_Conqueryoursel_compressed.jpg",
                                //"https://d3e11wjvplotyb.cloudfront.net/1654600113_anaganaga.jpg",
                                podcasts[index].imagepath!.isNotEmpty &&
                                        !podcasts[index]
                                            .imagepath!
                                            .contains(".jfif")
                                    ? podcasts[index].imagepath!
                                    : AppConstants.dummyPic,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e,s) {
                                  print(podcasts[index].imagepath!);
                                  print('error $s');
                                  return Container(color: Colors.blue,width: 100,height: 100,);
                                },
                              )),*/

                          ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    podcasts[index].imagepath!.isNotEmpty &&
                                            !podcasts[index]
                                                .imagepath!
                                                .contains(".jfif")
                                        ? podcasts[index].imagepath!
                                        : AppConstants.dummyPic,
                                width: cardWidth,
                                height: cardWidth,
                                memCacheWidth: cardWidth.toInt()*2,
                                memCacheHeight: cardWidth.toInt()*2,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )),
                          isPodcast
                              ? CircleAvatar(
                                  backgroundColor:
                                      AppColors.firstColor.withOpacity(0.5),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                        alignment: Alignment.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          podcasts[index].podcastName!,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          podcasts[index].description!,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12),
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
                      //callback!(podcasts[index]);

                      //Get.find<MainController>().updatePodcast(podcasts[index]);
                      //Get.find<MainController>().tomtomPlayer.addPodcast(podcasts[index]);
                      Get.find<MainController>()
                          .tomtomPlayer
                          .addAllPodcasts(podcasts, index);
                      Get.find<MainController>().togglePanel();

                      CommonNetworkApi().postViewed(podcasts[index].podcastId!);
                    },
                  ),
                )),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 10,
          );
        },
        itemCount: podcasts.length);
    // itemCount: podcasts.length>=5?5:podcasts.length);
  }
}
