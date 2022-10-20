import 'package:flutter/material.dart';
import 'package:podcast_app/components/pagination_cat_grid_item.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/category_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';


class PaginationCategoriesVertical extends StatefulWidget {
  const PaginationCategoriesVertical({
    Key? key,
  }) : super(key: key);

  @override
  State<PaginationCategoriesVertical> createState() =>
      _PaginationCategoriesVerticalState();
}

class _PaginationCategoriesVerticalState
    extends State<PaginationCategoriesVertical> {
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

    cardWidth = MediaQuery.of(MainPage.activeContext!).size.width / 2;

    _firstLoad();

    _controller = ScrollController()..addListener(_loadMore);
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
        _controller.position.extentAfter < 500) {
      // _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1

      try {
        final res = await ApiService().postData(
            ApiKeys.CATEGORIES_SUFFIX_PAGINATION, getPaginationQuery(_page));

        CategoryResponse response = CategoryResponse.fromJson(res);

        setState(() {
          categoriesList.addAll(response.categories!);
          _hasNextPage = totalRows != categoriesList.length;

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
          title: const Text(
            'Browse by Categories',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, right: 8.0, left: 8.0, bottom: kToolbarHeight),
          // top: 8.0, right: 8.0, left: 8.0, bottom: 100.0),
          child: _isFirstLoadRunning
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : categoriesList.isNotEmpty?GridView.builder(
                  padding: const EdgeInsets.only(bottom: 150),
                  itemCount: _isLoadMoreRunning
                      ? categoriesList.length + 1
                      : categoriesList.length,
                  controller: _controller,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 3 / 3.5, //3/3.75
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    if (index == categoriesList.length) {
                      return const SizedBox(
                          height: 100,
                          child: Center(child: CircularProgressIndicator()));
                    } else {
                      return PaginationCatGridItem(
                        category: categoriesList[index],
                        cardWidth: cardWidth,
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
    return {"page_number": page, "page_size": AppConstants.PAGE_SIZE_VERTICAL};
  }
}
