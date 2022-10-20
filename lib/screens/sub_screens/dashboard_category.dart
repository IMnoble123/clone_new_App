import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/models/item.dart';
import 'package:podcast_app/widgets/header.dart';

class DashBoardCategory extends StatelessWidget {
  final String? title;

  final List<Item>? items;
  final double? fontSize;
  final bool isPodcast;
  final VoidCallback? callback;

  const DashBoardCategory(
      {Key? key,
      this.title,
      this.items,
      this.callback,
      this.fontSize = 20,
      this.isPodcast = false,})
      : super(key: key);

  /*@override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          HeaderSection(
            title: title ?? '',
            callback: callback!,
            fontSize: fontSize!,
          ),
          SizedBox(
            height: 100,
            child: FutureBuilder(
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  return updateTilesData(snapShot.data);
                } else if (snapShot.hasError) {
                  return const Text(
                    'Error',
                    style: TextStyle(color: Colors.white),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
              future:
                  ApiService().fetchPodcastsByCategories({'category': categoryName!}),
            ),
          ),
        ],
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          HeaderSection(
            title: title ?? '',
            callback: callback!,
            fontSize: fontSize!,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [for (var item in items!) ItemWidget(context, item)],
            ),
          )
        ],
      ),
    );
  }

  /*Widget updateTilesData(dynamic data) {
    print(data);
    PodcastResponse response = PodcastResponse.fromJson(data);
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
                                width: 100,
                                height: 100,
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
                      if (isPodcast) {
                        Get.find<MainController>().togglePanel();
                      } else {
                        Navigator.pushNamed(
                            context, AppRoutes.podcastDetailsScreen);
                      }
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
        itemCount: 10);
  }*/

Widget ItemWidget(BuildContext context, Item item) {
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
                          item.imgUrl!,
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
                    item.title!,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.subtitle!,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.75), fontSize: 12),
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
                if (isPodcast) {
                  Get.find<MainController>().togglePanel();
                } else {
                  Navigator.pushNamed(context, AppRoutes.podcastDetailsScreen);
                }
              },
            ),
          )),
        ],
      ),
    );
  }
}
