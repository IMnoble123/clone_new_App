import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/components/podcast_item.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/header.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

import '../extras/constants.dart';
import '../models/response/podcast_response.dart';
import '../network/common_network_calls.dart';
import '../screens/main/main_page.dart';

class PaginationPodcasts extends StatefulWidget {
  final String? apiEndPoint;
  final String? headerTitle;
  final String? category;

  const PaginationPodcasts(
      {Key? key, this.apiEndPoint, this.headerTitle, this.category})
      : super(key: key);

  @override
  State<PaginationPodcasts> createState() => _PaginationPodcastsState();
}

class _PaginationPodcastsState extends State<PaginationPodcasts> {
  int _page = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  late ScrollController _controller;

  List<Podcast> podcastList = [];

  late var cardWidth; // = MediaQuery.of(MainPage.activeContext!).size.width/2-3*15;

  @override
  void initState() {
    super.initState();

    cardWidth = MediaQuery.of(MainPage.activeContext!).size.width / 2 - 3 * 15;

    _firstLoad();

    _controller = ScrollController()..addListener(_loadMore);
  }

  int totalRows = 0;

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final res = await ApiService()
          .postData(widget.apiEndPoint!, getPaginationQuery(_page));

      PodcastResponse response = PodcastResponse.fromJson(res);

      setState(() {
        podcastList = response.podcasts!;
        totalRows = int.parse(response.totalRows!);
      });
    } catch (e) {
      print(e.toString());
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 500) {
      // _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1

      try {
        final res = await ApiService()
            .postData(widget.apiEndPoint!, getPaginationQuery(_page));

        PodcastResponse response = PodcastResponse.fromJson(res);

        setState(() {
          podcastList.addAll(response.podcasts!);
          _hasNextPage = totalRows != podcastList.length;

          print('load more $_hasNextPage');
        });
      } catch (e) {
        print(e.toString());
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderSection(
          title: widget.headerTitle ?? '',
          callback: () {
            final args =
                ScreenArguments(widget.headerTitle!, widget.apiEndPoint!,'',filter: widget.category??'');
            Navigator.pushNamed(
                context, AppRoutes.podcastListScreenVerticalPagination,
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
                child: podcastList.isNotEmpty?ListView.builder(
                    itemCount: _isLoadMoreRunning
                        ? podcastList.length + 1
                        : podcastList.length,
                    controller: _controller,
                    itemBuilder: (context, index) {
                      if (index == podcastList.length) {
                        return SizedBox(
                            width: cardWidth,
                            child:
                                const Center(child: CircularProgressIndicator()));
                      } else {
                        return PodcastItem(
                          cardWidth: cardWidth,
                          podcast: podcastList[index],
                          callback: () {

                            Get.find<MainController>()
                                .tomtomPlayer
                                .addAllPodcasts(podcastList, index);
                            Get.find<MainController>().togglePanel();


                          },
                        );
                      }

                    },
                    scrollDirection: Axis.horizontal,
                  ):const Center(child: NoDataWidget(),),
              ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    _controller.dispose();
    super.dispose();
  }

  Map<String, dynamic> getPaginationQuery(int page) {
    return {
      "mob_user_id": CommonNetworkApi().mobileUserId,
      "category": widget.category ?? "",
      "page_number": page,
      "page_size": AppConstants.PAGE_SIZE
    };
  }
}
