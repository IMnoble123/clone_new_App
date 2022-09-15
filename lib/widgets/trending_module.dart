import 'package:flutter/material.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/header.dart';

class TrendingListView extends StatelessWidget {
  final String? headerTitle;
  final String? categoryName;
  final Function(Podcast)? callback;
  final Future<dynamic>? apiCall;
  final bool isPodcast;

  const TrendingListView(
      {Key? key,
      this.categoryName,
      this.callback,
      this.apiCall,
      this.isPodcast = true,
      this.headerTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Podcast> podcastList = [];
    return Column(
      children: [
        HeaderSection(
          title: headerTitle ?? '',
          callback: () {
            final args = ScreenArguments(headerTitle ?? '', '', podcastList);
            Navigator.pushNamed(context, AppRoutes.podcastListScreen,
                arguments: args);
          },
        ),
        SizedBox(
          height: 150,
          child: FutureBuilder(
            builder: (context, snapShot) {
              if (snapShot.hasData) {

                PodcastResponse response = PodcastResponse.fromJson(snapShot.data as dynamic);

                if (response.status == "Error") {
                  return Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'No Data',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                List<Podcast> podcasts = response.podcasts!;
                podcastList = podcasts;

                return updateTilesData(podcasts, categoryName!);
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
            future: apiCall,
            // future: ApiService().fetchTrendingPodcasts(),
          ),
        ),
      ],
    );
  }

  /*Widget updateTilesData(dynamic data, String catName) {
    print(data);

    PodcastResponse response = PodcastResponse.fromJson(data);

    if (response.status == "Error") {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'No Data',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    List<Podcast> podcasts = response.podcasts!;*/

    Widget updateTilesData(List<Podcast> podcasts, String catName) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
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
                              child: Image.network(
                                podcasts[index].imagepath!.isNotEmpty
                                    ? podcasts[index].imagepath!
                                    : AppConstants.dummyPic,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,cacheWidth: 100,cacheHeight: 100,
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
                      callback!(podcasts[index]);
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
  }
}
