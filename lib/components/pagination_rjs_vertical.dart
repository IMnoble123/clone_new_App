import 'package:flutter/material.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/rj_row_item.dart';
import '../network/common_network_calls.dart';

class PaginationRjsVertical extends StatefulWidget {
  final String? apiEndPoint;
  final String? headerTitle;
  final String? category;

  const PaginationRjsVertical(
      {Key? key, this.apiEndPoint, this.headerTitle, this.category})
      : super(key: key);

  @override
  State<PaginationRjsVertical> createState() => _PaginationRjsVerticalState();
}

class _PaginationRjsVerticalState extends State<PaginationRjsVertical> {
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
            widget.headerTitle!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, right: 8.0, left: 8.0, bottom: kToolbarHeight),
          child: _isFirstLoadRunning
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  padding: const EdgeInsets.only(bottom: 150),
                  itemCount:
                      _isLoadMoreRunning ? rjsList.length + 1 : rjsList.length,
                  controller: _controller,
                  itemBuilder: (context, index) {
                    if (index == rjsList.length) {
                      return const SizedBox(
                          height: 100,
                          child: Center(child: CircularProgressIndicator()));
                    } else {
                      return RjRowItem(
                        rjItem: rjsList[index],
                      );
                    }
                  },
                  separatorBuilder: (c, i) {
                    return const Divider();
                  },
                  scrollDirection: Axis.vertical,
                ),
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
      "category": widget.category ?? "",
      "page_number": page,
      "page_size": AppConstants.PAGE_SIZE_VERTICAL
    };
  }
}
