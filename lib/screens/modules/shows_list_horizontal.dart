import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/shows_response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/header.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

class showsListHorizontal extends StatelessWidget {
  final String? headerTitle;
  final String apiSuffix;
  final Map<String, dynamic>? query;
  final VoidCallback? callback;

  const showsListHorizontal(
      {Key? key,
      this.headerTitle,
      required this.apiSuffix,
      this.query,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    var cardWidth = MediaQuery.of(MainPage.activeContext!).size.width/2-3*15;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          HeaderSection(
            title: headerTitle ?? '',
            callback: () {
              if (callback != null) callback!();
            },
          ),
          SizedBox(
            height: cardWidth+50,
            child: FutureBuilder(
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  try {
                    ShowsResponseData response =
                        ShowsResponseData.fromJson(snapShot.data as dynamic);

                    if (response.status == "Error" ||
                        response.showsList == null) {
                      return const NoDataWidget();
                    }

                    return updateShowsData(response.showsList!,cardWidth);
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
            ),
          ),
        ],
      ),
    );
  }

  Widget updateShowsData(List<ShowItem> shows,cardWidth) {


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
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: shows[index].showsImage!.isNotEmpty &&
                                    !shows[index].showsImage!.contains(".jfif")
                                ? shows[index].showsImage!
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          shows[index].showsName!,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                      /*Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${shows[index].totalPodcast!} episodes ',
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
                      final args = ScreenArguments(
                          // '${shows[index].showsName!} (${shows[index].totalPodcast})',
                          shows[index].showsName!,
                          ApiKeys.PODCASTS_BY_SHOW_SUFFIX,
                          ApiKeys.getPodcastsByShowIdQuery(
                              shows[index].showsId!));
                      Navigator.pushNamed(
                          context, AppRoutes.podcastListScreenVertical,
                          arguments: args);
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
        itemCount: shows.length);
  }
}
