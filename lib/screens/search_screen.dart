import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/search_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/models/response/search_response_data.dart';
import 'package:podcast_app/models/response/shows_response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/rj_row_item.dart';
import 'package:podcast_app/widgets/song_info_tile.dart';

class SearchScreen extends GetView<SearchController> {
  const SearchScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();

    return Container(
      /*decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover))*/
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 54, 0, 0), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.5])),
      child: SingleChildScrollView(
        child: Column(
          children: [
            /*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                child: Obx(() => filterItems()),
                height: 50,
              ),
            ),*/
            Obx(() => controller.searchText.isEmpty
                ? const SizedBox(
                    height: 300,
                    child: Center(
                        child: Text(
                      'Search by Podcast, Rj and more.',
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
                      future: ApiService().postData(ApiKeys.SEARCH_NEW_SUFFIX,
                          getQuery(controller.searchText.value)),
                      // future: ApiService().fetchSearchResults(getQuery(controller.searchText.value)),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );
  }

  /*return Container(
      */ /*decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover))*/ /*
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 54, 0, 0), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.5])),
      child: Column(
        children: [
          */ /*Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              child: Obx(() => filterItems()),
              height: 50,
            ),
          ),*/ /*
          Obx(() => controller.searchText.isEmpty
              ? const SizedBox(
                  height: 300,
                  child: Center(
                      child: Text(
                    'Search by Podcast, Rj and more.',
                    style: TextStyle(color: Colors.white),
                  )))
              : const SizedBox.shrink()),
          Obx(
            () => controller.searchText.value.isNotEmpty
                ? FutureBuilder(
                    builder: (context, snapShot) {
                      if (snapShot.hasData) {
                        return updateTilesData(snapShot.data);
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
                    future: ApiService().fetchSearchResults(
                        getQuery(controller.searchText.value)),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }*/

  /*Widget updateTilesData(dynamic data) {
    print(data);

    PodcastResponse response = PodcastResponse.fromJson(data);

    if (response.status == "Error") {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'No Results',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    List<Podcast> podcasts = response.podcasts!;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return SongInfoTile(
                podcast: podcasts[index],
                callback: () {
                  Get.find<MainController>()
                      .tomtomPlayer
                      .addAllPodcasts(podcasts, index);
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: podcasts.length),
      ),
    );
    */ /*return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3 / 4,
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
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
                                height: 100,
                              )),
                          CircleAvatar(
                            backgroundColor:
                                AppColors.firstColor.withOpacity(0.5),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          )
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
                      Get.back();
                      Get.find<MainController>().updatePodcast(podcasts[index]);
                      Get.find<MainController>().togglePanel();
                      CommonNetworkApi().postViewed(podcasts[index].podcastId!);
                    },
                  ),
                )),
              ],
            ),
          );
        },
        itemCount: podcasts.length);*/ /*
  }*/

  Widget displaySearchResults(dynamic data) {
    print('From Search $data');
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
      List<RjItem> searchRjs = response.response!.rjList!;
      List<ShowItem> showsList = response.response!.showsList!;
      searchPodcasts.sort((a, b) => a.podcastName!.compareTo(b.podcastName!));

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          children: [
            ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return SongInfoTile(
                    podcast: searchPodcasts[index],
                    callback: () {
                      Get.find<MainController>()
                          .tomtomPlayer
                          .addAllPodcasts(searchPodcasts, index);

                      CommonNetworkApi()
                          .postViewed(searchPodcasts[index].podcastId!);
                    },
                    playAll: () {
                      Get.find<MainController>()
                          .tomtomPlayer
                          .addAllPodcasts(searchPodcasts, 0);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: searchPodcasts.length),
            searchRjs.isNotEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'RJ\'s Results',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                : const SizedBox.shrink(),
            ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (c, index) {
                  return RjRowItem(
                    rjItem: searchRjs[index],
                    callback: () {
                      controller.closeSearchPanel();

                      Navigator.pushNamed(MainPage.activeContext!,
                          AppRoutes.podcastDetailsScreen,
                          arguments: searchRjs[index]);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: searchRjs.length),
            showsList.isNotEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      'Shows Results',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                : const SizedBox.shrink(),
            ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (c, index) {
                  return showItem(
                    showsList[index],
                    c,
                    () {
                      controller.closeSearchPanel();

                      FocusScope.of(c).unfocus();

                      final args = ScreenArguments(
                          '${showsList[index].showsName!} (${showsList[index].totalPodcast})',
                          ApiKeys.PODCASTS_BY_SHOW_SUFFIX,
                          ApiKeys.getPodcastsByShowIdQuery(
                              showsList[index].showsId!));
                      Navigator.pushNamed(MainPage.activeContext!,
                          AppRoutes.podcastListScreenVertical,
                          arguments: args);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: showsList.length),
          ],
        ),
      );
    } catch (e) {
      print(e);
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'No Results',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    /*return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 3 / 4,
            crossAxisCount: 3,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
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
                                height: 100,
                              )),
                          CircleAvatar(
                            backgroundColor:
                                AppColors.firstColor.withOpacity(0.5),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          )
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
                      Get.back();
                      Get.find<MainController>().updatePodcast(podcasts[index]);
                      Get.find<MainController>().togglePanel();
                      CommonNetworkApi().postViewed(podcasts[index].podcastId!);
                    },
                  ),
                )),
              ],
            ),
          );
        },
        itemCount: podcasts.length);*/
  }

  /*Map<String, dynamic> getSearchQuery(String value) {
    //return {"keyword": value.isNotEmpty?value:"telugu"};

    return {"keyword":"mirchi"};
  }*/
  Map<String, dynamic> getQuery(String value) {
    return {"keyword": value, "mob_user_id": CommonNetworkApi().mobileUserId};
    // return {"keyword": value.isNotEmpty ? value : "telugu"};
  }

  filterItems() {
    final controller = Get.find<MainController>();

    return Theme(
      data: ThemeData(canvasColor: Colors.transparent),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ChoiceChip(
            label: const Text(
              'All',
              style: TextStyle(color: Colors.white),
            ),
            selected: controller.filterChipSelectedIndex.value == 0,
            selectedColor: Colors.white.withOpacity(0.2),
            backgroundColor: Colors.white.withOpacity(0.2),
            shape: controller.filterChipSelectedIndex.value == 0
                ? const StadiumBorder(
                    side: BorderSide(color: AppColors.firstColor))
                : null,
            onSelected: (selected) {
              controller.updateFilterChipSelectedIndex(0);
            },
          ),
          const SizedBox(
            width: 10,
          ),
          ChoiceChip(
            label: const Text(
              'Podcast',
              style: TextStyle(color: Colors.white),
            ),
            selected: controller.filterChipSelectedIndex.value == 1,
            selectedColor: Colors.white.withOpacity(0.2),
            backgroundColor: Colors.white.withOpacity(0.2),
            shape: controller.filterChipSelectedIndex.value == 1
                ? const StadiumBorder(
                    side: BorderSide(color: AppColors.firstColor))
                : null,
            onSelected: (selected) {
              controller.updateFilterChipSelectedIndex(1);
            },
          ),
          const SizedBox(
            width: 10,
          ),
          ChoiceChip(
            label: const Text(
              'RJs',
              style: TextStyle(color: Colors.white),
            ),
            selected: controller.filterChipSelectedIndex.value == 2,
            selectedColor: Colors.white.withOpacity(0.2),
            backgroundColor: Colors.white.withOpacity(0.2),
            shape: controller.filterChipSelectedIndex.value == 2
                ? const StadiumBorder(
                    side: BorderSide(color: AppColors.firstColor))
                : null,
            onSelected: (selected) {
              controller.updateFilterChipSelectedIndex(2);
            },
          ),
          const SizedBox(
            width: 10,
          ),
          ChoiceChip(
            label: const Text(
              'Categories',
              style: TextStyle(color: Colors.white),
            ),
            selected: controller.filterChipSelectedIndex.value == 3,
            selectedColor: Colors.white.withOpacity(0.2),
            backgroundColor: Colors.white.withOpacity(0.2),
            shape: controller.filterChipSelectedIndex.value == 3
                ? const StadiumBorder(
                    side: BorderSide(color: AppColors.firstColor))
                : null,
            onSelected: (selected) {
              controller.updateFilterChipSelectedIndex(3);
            },
          ),
          const SizedBox(
            width: 10,
          ),
          ChoiceChip(
            label: const Text(
              'Topics',
              style: TextStyle(color: Colors.white),
            ),
            selected: controller.filterChipSelectedIndex.value == 4,
            selectedColor: Colors.white.withOpacity(0.2),
            backgroundColor: Colors.white.withOpacity(0.2),
            shape: controller.filterChipSelectedIndex.value == 4
                ? const StadiumBorder(
                    side: BorderSide(color: AppColors.firstColor))
                : null,
            onSelected: (selected) {
              controller.updateFilterChipSelectedIndex(4);
            },
          ),
        ],
      ),
    );
  }

  Container showItem(ShowItem showItem, BuildContext c, VoidCallback callback) {
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
                      imageUrl: showItem.showsImage!.isNotEmpty &&
                              !showItem.showsImage!.contains(".jfif")
                          ? showItem.showsImage!
                          : AppConstants.dummyPic,
                      width: 75,
                      height: 75,
                      memCacheWidth: 75,
                      memCacheHeight: 75,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )),
              ]),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showItem.showsName ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      ' ${showItem.totalPodcast ?? '0'} episodes',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.disableColor,
                      ),
                    )
                  ],
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.5),
                ),
              )
            ],
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                //Get.find<MainController>().togglePanel();

                callback();
              },
            ),
          ))
        ],
      ),
    );
  }
}
