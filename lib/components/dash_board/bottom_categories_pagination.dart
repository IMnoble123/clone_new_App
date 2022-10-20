import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/components/pagination_podcasts.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/category_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

class BottomCategoriesPagination extends StatefulWidget {
  const BottomCategoriesPagination({Key? key}) : super(key: key);

  @override
  State<BottomCategoriesPagination> createState() =>
      _BottomCategoriesPaginationState();
}

class _BottomCategoriesPaginationState
    extends State<BottomCategoriesPagination> {
  int _page = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  late ScrollController _controller;

  List<Category> categoriesList = [];

  late var cardWidth;

  @override
  void initState() {
    super.initState();

    cardWidth = MediaQuery.of(MainPage.activeContext!).size.width / 2 - 3 * 15;

    Future.delayed(const Duration(seconds: 3), () {
      _firstLoad();

      _controller = Get.find<MainController>().scrollController;
      _controller.addListener(_loadMore);

    });




  }

  int totalRows = 0;

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      final res = await ApiService().postData(
          ApiKeys.CATEGORIES_SUFFIX_PAGINATION, getPaginationQuery(_page));

      CategoryResponse response = CategoryResponse.fromJson(res);

      setState(() {
        categoriesList = response.categories!;
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
        _controller.position.extentAfter < 300) {
      // _controller.position.extentAfter < 300) {

      if (mounted) {
        setState(() {
          _isLoadMoreRunning =
              true; // Display a progress indicator at the bottom
        });
      }

      _page += 1; // Increase _page by 1

      try {
        final res = await ApiService().postData(
            ApiKeys.CATEGORIES_SUFFIX_PAGINATION, getPaginationQuery(_page));

        CategoryResponse response = CategoryResponse.fromJson(res);

        if (mounted) {
          setState(() {
            categoriesList.addAll(response.categories!);
            _hasNextPage = totalRows != categoriesList.length;

            log('load more $_hasNextPage');
          });
        }
      } catch (e) {
        log(e.toString());
      }

      if (mounted) {
        setState(() {
          _isLoadMoreRunning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstLoadRunning
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : categoriesList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                primary: false,
                //controller: _controller,
                itemBuilder: (context, index) {
                  if (index == categoriesList.length) {
                    return const SizedBox(
                        height: 100,
                        child: Center(child: CircularProgressIndicator()));
                  } else {
                    return PaginationPodcasts(
                      apiEndPoint: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
                      headerTitle: categoriesList[index].name,
                      category: categoriesList[index].name,
                    );
                  }
                },
                itemCount: _isLoadMoreRunning
                    ? categoriesList.length + 1
                    : categoriesList.length,
              )
            : const Center(
                child: NoDataWidget(),
              );
  }

  Map<String, dynamic> getPaginationQuery(int page) {
    return {
      // "mob_user_id": CommonNetworkApi().mobileUserId,
      "page_number": page,
      "page_size": AppConstants.PAGE_SIZE
    };
  }
}
