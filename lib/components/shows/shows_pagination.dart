import 'package:flutter/material.dart';
import 'package:podcast_app/components/shows/pagination_show_Item.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/keys.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/shows_response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/header.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

class PaginationShows extends StatefulWidget {
  final String? apiEndPoint;
  final String? headerTitle;
  final String? category;

  const PaginationShows(
      {Key? key, this.apiEndPoint, this.headerTitle, this.category})
      : super(key: key);

  @override
  State<PaginationShows> createState() => _PaginationShowsState();
}

class _PaginationShowsState extends State<PaginationShows> {
  int _page = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  late ScrollController _controller;

  List<ShowItem> showsList = [];

  late var cardWidth;

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

      ShowsResponseData response = ShowsResponseData.fromJson(res);

      setState(() {
        showsList = response.showsList!;
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

        ShowsResponseData response = ShowsResponseData.fromJson(res);

        setState(() {
          showsList.addAll(response.showsList!);
          _hasNextPage = totalRows != showsList.length;

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
            final args = ScreenArguments(
                widget.headerTitle!, widget.apiEndPoint!, '',
                filter: widget.category??'');
            Navigator.pushNamed(
                context, AppRoutes.showsListScreenVerticalPagination,
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
                  child: showsList.isNotEmpty?ListView.builder(
                    itemCount: _isLoadMoreRunning
                        ? showsList.length + 1
                        : showsList.length,
                    controller: _controller,
                    itemBuilder: (context, index) {
                      if (index == showsList.length) {
                        return SizedBox(
                            width: cardWidth,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      } else {
                        return PaginationShowItem(
                          cardWidth: cardWidth,
                          showItem: showsList[index],
                          callback: () {

                            final args =
                            ScreenArguments(showsList[index].showsName!, ApiKeys.PODCASTS_BY_SHOW_SUFFIX,'',filter: showsList[index].showsId!);
                            Navigator.pushNamed(
                                context, AppRoutes.showPodcastsScreenVerticalPagination,
                                arguments: args);

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
