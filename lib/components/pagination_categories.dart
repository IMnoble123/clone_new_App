import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/components/pagination_cat_item.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/category_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/header.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

class PaginationCategories extends StatefulWidget {
  final String? apiEndPoint;
  final String? headerTitle;


  const PaginationCategories({Key? key, this.apiEndPoint, this.headerTitle})
      : super(key: key);

  @override
  State<PaginationCategories> createState() => _PaginationCategoriesState();
}

class _PaginationCategoriesState extends State<PaginationCategories> {
  int _page = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;

  late ScrollController _controller;

  List<Category> categoriesList = [];

  late var cardWidth; // = MediaQuery.of(MainPage.activeContext!).size.width/2-3*15;

  late MainController mainController;

  @override
  void initState() {
    super.initState();

    cardWidth = MediaQuery.of(MainPage.activeContext!).size.width / 2 - 3 * 15;

    mainController = Get.find<MainController>();

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

      CategoryResponse response = CategoryResponse.fromJson(res);

      setState(() {
        categoriesList = response.categories!;
        totalRows = int.parse(response.totalRows!);
      });

      Future.delayed(const Duration(seconds: 3), () {
        mainController.categories.clear();
        // mainController.categories.value = response.categories!;
        mainController.categories.addAll(response.categories!);
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

        CategoryResponse response = CategoryResponse.fromJson(res);

        setState(() {
          categoriesList.addAll(response.categories!);
          _hasNextPage = totalRows != categoriesList.length;

          print('load more $_hasNextPage');
        });

         Future.delayed(const Duration(seconds: 2), () {
           mainController.categories.addAll(response.categories!);
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
              widget.headerTitle!,
              widget.apiEndPoint!,
              '',
            );
            Navigator.pushNamed(context, AppRoutes.browseCategoriesPagination);
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
                  child: categoriesList.isNotEmpty?ListView.builder(
                    itemCount: _isLoadMoreRunning
                        ? categoriesList.length + 1
                        : categoriesList.length,
                    controller: _controller,
                    itemBuilder: (context, index) {
                      if (index == categoriesList.length) {
                        return SizedBox(
                            width: cardWidth,
                            child: const Center(
                                child: CircularProgressIndicator()));
                      } else {
                        return PaginationCatItem(
                          cardWidth: cardWidth,
                          category: categoriesList[index],
                          callback: () {
                            Navigator.of(context).pushNamed(
                                AppRoutes.podcastListCategory,
                                arguments: ScreenArguments(
                                    categoriesList[index].name!,
                                    categoriesList[index].name!,
                                    ''));
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
      // "mob_user_id": CommonNetworkApi().mobileUserId,
      "page_number": page,
      "page_size": AppConstants.PAGE_SIZE
    };
  }

  void updateCategories(List<Category> list) {
    list.forEach((element) {
      if (!mainController.categories.contains(element)) {
        mainController.categories.value.add(element);
      }
    });
  }
}
