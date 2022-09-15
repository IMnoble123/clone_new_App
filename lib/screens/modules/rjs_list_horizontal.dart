import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/header.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

import '../main/main_page.dart';

class RjsListHorizontal extends StatelessWidget {
  final String? headerTitle;
  final String apiSuffix;
  final Map<String, dynamic>? query;
  final bool isPodcast;

  const RjsListHorizontal(
      {Key? key,
      this.headerTitle,
      required this.apiSuffix,
      this.isPodcast = true,
      this.query})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<RjItem> rjItems = [];

    var cardWidth =
        MediaQuery.of(MainPage.activeContext!).size.width / 2 - 3 * 15;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          HeaderSection(
            title: headerTitle ?? '',
            callback: () {


              final args =
                  ScreenArguments('Creators', ApiKeys.TOP_50_RJS_SUFFIX, query);
              Navigator.pushNamed(context, AppRoutes.rjsListScreenVertical,
                  arguments: args);

            },
          ),
          SizedBox(
            height: cardWidth + 50,
            child: FutureBuilder(
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  try {
                    RjResponse response =
                        RjResponse.fromJson(snapShot.data as dynamic);

                    if (response.status == "Error" ||
                        response.rjItems == null) {
                      return const NoDataWidget();
                    }

                    rjItems = response.rjItems!;

                    return updateTilesData(rjItems, cardWidth);
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
              future: ApiService().fetchPodcasts(apiSuffix, query ?? {}),
              // future: ApiService().fetchTrendingPodcasts(),
            ),
          ),
        ],
      ),
    );
  }

  Widget updateTilesData(List<RjItem> rjItems, cardWidth) {
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
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
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: CachedNetworkImage(
                                imageUrl: rjItems[index]
                                        .profileImage!
                                        .isNotEmpty /*&&
                                    !rjItems[index].profileImage!.contains(".jfif")*/
                                    ? rjItems[index].profileImage!
                                    : AppConstants.dummyRjPic,
                                width: cardWidth,
                                height: cardWidth,
                                fit: BoxFit.cover,
                                memCacheWidth: cardWidth.toInt() * 2,
                                memCacheHeight: cardWidth.toInt() * 2,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )),
                          /*ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                rjItems[index].profileImage!.isNotEmpty
                                    ? rjItems[index].profileImage!
                                    : AppConstants.dummyPic,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              )),*/
                        ],
                        alignment: Alignment.center,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          rjItems[index].rjName!,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                      /* Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          rjItems[index].podcasterType!,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12),
                        ),
                      ),*/
                    ],
                  ),
                ),
                Positioned.fill(
                    child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      //callback!(rjItems[index]);
                      Navigator.pushNamed(
                          context, AppRoutes.podcastDetailsScreen,
                          arguments: rjItems[index]);
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
        itemCount: rjItems.length);
    // itemCount: rjItems.length >= 10 ? 10 : rjItems.length);
  }
}
