import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';
import 'package:podcast_app/widgets/song_info_tile.dart';

class PaginationShowsPodcastsVertical extends StatefulWidget {
  final String apiEndPoint;
  final String headerTitle;
  final String showId;

  const PaginationShowsPodcastsVertical(
      {Key? key,
      required this.apiEndPoint,
      required this.headerTitle,
      required this.showId})
      : super(key: key);

  @override
  State<PaginationShowsPodcastsVertical> createState() =>
      _PaginationShowsPodcastsVerticalState();
}

class _PaginationShowsPodcastsVerticalState
    extends State<PaginationShowsPodcastsVertical> {

  int _page = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  late ScrollController _controller;

  List<Podcast> podcastList = [];

  @override
  void initState() {
    super.initState();

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
          .postData(widget.apiEndPoint, getPaginationQuery(_page));

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
            .postData(widget.apiEndPoint, getPaginationQuery(_page));

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
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 54, 0, 0), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.5])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            widget.headerTitle,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0,bottom: 100.0),
          child: _isFirstLoadRunning
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : podcastList.isNotEmpty?ListView.separated(
            padding: const EdgeInsets.only(bottom: 150),
            itemCount: _isLoadMoreRunning
                ? podcastList.length + 1
                : podcastList.length,
            controller: _controller,
            separatorBuilder: (context, index) {

              return const Divider();
            },
            itemBuilder: (context, index) {
              if (index == podcastList.length) {
                return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()));
              } else {
                return SongInfoTile(
                  podcast: podcastList[index],
                  callback: () {
                    Get.find<MainController>()
                        .tomtomPlayer
                        .addAllPodcasts(podcastList, index);

                    CommonNetworkApi()
                        .postViewed(podcastList[index].podcastId!);
                  },
                  longCallback: () {},
                  playAll: () {
                    Get.find<MainController>()
                        .tomtomPlayer
                        .addAllPodcasts(podcastList, 0);
                  },
                );
              }
            },
            scrollDirection: Axis.vertical,
          ):const Center(child: NoDataWidget(),),
        ),
      ),
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
      "shows_id": widget.showId,
      "page_number": page,
      "page_size": AppConstants.PAGE_SIZE_VERTICAL
    };
  }

}
