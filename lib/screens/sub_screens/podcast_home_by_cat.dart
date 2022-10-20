import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/widgets/trending_module.dart';

import '../dash_board.dart';
import 'dashboard_category.dart';

class PodcastHomeBycategory extends StatelessWidget {
  final String title;
  final String titleKey;

  const PodcastHomeBycategory({Key? key, required this.title, required this.titleKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover)),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(children: [
              DashBoardCategory(
                title: 'Continue from where you stoped',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('Continue from where you stoped');
                },
              ),

              /*Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: HeaderSection(
                  title: 'Trending Topics',
                  callback: (){},
                  fontSize: 16,
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: HorizontalScrollItems(keyName: titleKey,isPodcast: true,callback: (podcast){
                  print(podcast.imagepath!);
                  Get.find<MainController>().updatePodcast(podcast);
                  Get.find<MainController>().togglePanel();

                },),
              ),*/

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [

                    TrendingListView(
                      categoryName: '', headerTitle: 'Trending Topics',
                      callback: (podcast) {

                        Get.find<MainController>().updatePodcast(podcast);
                        Get.find<MainController>().togglePanel();

                        //postViewed(podcast.podcastId!);

                        CommonNetworkApi().postViewed(podcast.podcastId!);

                      },
                      apiCall: ApiService().fetchPodcastsByCategories(getBody(titleKey)),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [

                    TrendingListView(
                      categoryName: '', headerTitle: 'TOP 50 New RJs',
                      callback: (podcast) {

                        Get.find<MainController>().updatePodcast(podcast);
                        Get.find<MainController>().togglePanel();

                        //postViewed(podcast.podcastId!);

                        CommonNetworkApi().postViewed(podcast.podcastId!);

                      },
                      apiCall: ApiService().fetchTop50Podcasts(),
                    ),
                  ],
                ),
              ),

              DashBoardCategory(
                title: 'Trending Topics',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('Trending Topics');
                },
              ),
              DashBoardCategory(
                title: 'TOP 50 New RJs',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('TOP 50 New RJs');
                },
              ),
              DashBoardCategory(
                title: 'Top 10 New Podcasts',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('Top 10 New Podcasts');
                },
              ),
              DashBoardCategory(
                title: 'Podcasts you listened',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('Podcasts you listened');
                },
              ),
              DashBoardCategory(
                title: 'Topics of News (Weather/Central…)',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('Topics of News (Weather/Central…)');
                },
              ),
            ]),
          )),
        ],
      ),
    );

    /*return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover)),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
            DashBoardCategory(
                title: 'Continue from where you stoped',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('Continue from where you stoped');
                },
            ),
            DashBoardCategory(
                title: 'Trending Topics',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('Trending Topics');
                },
            ),
            DashBoardCategory(
                title: 'TOP 50 New RJs',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('TOP 50 New RJs');
                },
            ),
            DashBoardCategory(
                title: 'Top 10 New Podcasts',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('Top 10 New Podcasts');
                },
            ),
            DashBoardCategory(
                title: 'Your Listend Podcasts',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('Your Listend Podcasts');
                },
            ),DashBoardCategory(
                title: 'Topics of News (Weather/Central…)',
                fontSize: 16,
                items: DashBoardScreen.items,
                callback: () {
                  pushScreen('Topics of News (Weather/Central…)');
                },
            ),
          ]),
              )),
        ],
      ),
    );*/
  }

  void pushScreen(String s) {}

  /*void postViewed(String podcastId) async {
    Map<String, String> query = {"podcast_id": podcastId, "mob_user_id": "-1"};

    await ApiService().postPodcastView(query);

  }*/

  Map<String, dynamic> getBody(String title) {
    return {'category': title};
  }



}
