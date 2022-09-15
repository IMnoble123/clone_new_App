import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/components/podcast_item.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/header.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

class ListenedPodcasts extends StatefulWidget {
  final String? category;

  const ListenedPodcasts(
      {Key? key,  this.category})
      : super(key: key);

  @override
  State<ListenedPodcasts> createState() => _ListenedPodcastsState();
}

class _ListenedPodcastsState extends State<ListenedPodcasts> {
  List<Podcast> podcastList = [];

  bool _isFirstLoadRunning = false;

  late var cardWidth;

  @override
  void initState() {
    super.initState();

    cardWidth = MediaQuery.of(MainPage.activeContext!).size.width / 2 - 3 * 15;

    loadData();
  }

  void loadData() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final res = await ApiService()
          .postData(ApiKeys.YOUR_LISTENED_PODCAST_SUFFIX, ApiKeys.getCatQuery(widget.category??''));
          // .postData(ApiKeys.YOUR_LISTENED_PODCAST_SUFFIX, ApiKeys.getMobileUserQuery());

      PodcastResponse response = PodcastResponse.fromJson(res);

      setState(() {
        podcastList = response.podcasts!;
      });
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_isFirstLoadRunning && podcastList.isNotEmpty
        ? Column(
            children: [
              HeaderSection(
                title: 'Podcasts you listened',
                callback: () {
                  final args = ScreenArguments(
                      'Podcasts you listened',
                      ApiKeys.YOUR_LISTENED_PODCAST_SUFFIX,
                      ApiKeys.getCatQuery(widget.category ?? ''));
                  // ApiKeys.getMobileUserQuery());
                  Navigator.pushNamed(
                      context, AppRoutes.podcastListScreenVertical,
                      arguments: args);
                },
              ),
              SizedBox(
                height: cardWidth + 50,
                child: _isFirstLoadRunning
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: podcastList.isNotEmpty
                            ? ListView.builder(
                                itemCount: podcastList.length,
                                itemBuilder: (context, index) {
                                  if (index == podcastList.length) {
                                    return SizedBox(
                                        width: cardWidth,
                                        child: const Center(
                                            child:
                                                CircularProgressIndicator()));
                                  } else {
                                    return PodcastItem(
                                      cardWidth: cardWidth,
                                      podcast: podcastList[index],
                                      callback: () {
                                        Get.find<MainController>()
                                            .tomtomPlayer
                                            .addAllPodcasts(podcastList, index);
                                        Get.find<MainController>()
                                            .togglePanel();
                                      },
                                    );
                                  }
                                },
                                scrollDirection: Axis.horizontal,
                              )
                            : const Center(
                                child: NoDataWidget(),
                              ),
                      ),
              )
            ],
          )
        : const SizedBox.shrink();
  }
}
