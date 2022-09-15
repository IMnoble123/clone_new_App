import 'package:flutter/material.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/network/api_services.dart';

class HorizontalScrollItems extends StatelessWidget {
  final String keyName;
  final bool isPodcast;
  final Function(Podcast)? callback;

  const HorizontalScrollItems(
      {Key? key, required this.keyName, this.isPodcast = true, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: FutureBuilder(
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return updateTilesData(snapShot.data, isPodcast);
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
        future: ApiService().fetchPodcastsByCategories(getQuery(keyName)),
      ),
    );
  }

  Widget updateTilesData(dynamic data, bool isPodcast) {
    print(data);
    PodcastResponse response = PodcastResponse.fromJson(data);
    if (response.status == "Error") return Container();

    List<Podcast> podcasts = response.podcasts!;
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
                                podcasts[index].imagepath!,
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
                      /*if (isPodcast) {
                        Get.find<MainController>().togglePanel();
                      } else {
                        Navigator.pushNamed(
                            context, AppRoutes.podcastDetailsScreen);
                      }*/
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

  Map<String, dynamic> getQuery(String keyName) {
    return {"category": keyName};
  }
}
