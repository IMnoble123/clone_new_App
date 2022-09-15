import 'package:flutter/material.dart';
import 'package:podcast_app/components/rj_item.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/header.dart';

import '../network/common_network_calls.dart';

class PaginationRjs extends StatefulWidget {
  final String? apiEndPoint;
  final String? headerTitle;
  final String? category;

  const PaginationRjs(
      {Key? key, this.apiEndPoint, this.headerTitle, this.category})
      : super(key: key);

  @override
  State<PaginationRjs> createState() => _PaginationRjsState();
}

class _PaginationRjsState extends State<PaginationRjs> {
  int _page = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  late ScrollController _controller;

  List<RjItem> rjsList = [];

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

      RjResponse response = RjResponse.fromJson(res);

      setState(() {
        rjsList = response.rjItems!;
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

        RjResponse response = RjResponse.fromJson(res);

        setState(() {
          rjsList.addAll(response.rjItems!);
          _hasNextPage = totalRows != rjsList.length;

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
                'Creators', widget.apiEndPoint!, '',
                filter: widget.category??'');
            Navigator.pushNamed(
                context, AppRoutes.rjsListScreenVerticalPagination,
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
                  child: ListView.builder(
                    itemCount: _isLoadMoreRunning
                        ? rjsList.length + 1
                        : rjsList.length,
                    controller: _controller,
                    itemBuilder: (context, index) {
                      if (index == rjsList.length) {
                        return SizedBox(
                            width: cardWidth,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      } else {
                        return RjPaginationItem(
                          cardWidth: cardWidth,
                          rjItem: rjsList[index],
                          callback: () {
                            Navigator.pushNamed(
                                context, AppRoutes.podcastDetailsScreen,
                                arguments: rjsList[index]);
                          },
                        );
                      }
                    },
                    scrollDirection: Axis.horizontal,
                  ),
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
