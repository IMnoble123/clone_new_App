import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/components/dash_board/bottom_categories_pagination.dart';
import 'package:podcast_app/components/listened_podcasts.dart';
import 'package:podcast_app/components/pagination_categories.dart';
import 'package:podcast_app/components/pagination_rjs.dart';
import 'package:podcast_app/components/shows/shows_pagination.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/item.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/ad_spot.dart';
import 'package:podcast_app/widgets/menus_title.dart';

import '../components/pagination_podcasts.dart';

class DashBoardScreen extends GetView<MainController> {
  final ValueChanged<int>? onPush;

  const DashBoardScreen({Key? key, this.onPush}) : super(key: key);

  static final List<Item> _items = List.generate(
      10,
          (index) => Item.fromJson({
        "id": 1,
        "imgUrl":
        "https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/6a/e4/59/6ae45956-8b3d-0ff2-81f8-587c7c65b515/source/512x512bb.jpg",
        "title": "Title",
        "subtitle": "SubTitle"
      }));

  static get items => _items;

  @override
  Widget build(BuildContext context) {
    print('Main Screen rebuild');

    MainPage.activeContext = context;

    return SingleChildScrollView(
      controller: controller.scrollController,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MenusTitle(text: 'Discover'),
            // const Text('Discover the Best of podcast for you',style: TextStyle(color: Colors.white,fontSize: 12),),
            const Text(
              'Discover your next favourite podcast here',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const AdSpotWidget(),
            SizedBox(
              height: 50,
              child: Obx(
                    () => Theme(
                  data: ThemeData(canvasColor: Colors.transparent),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ChoiceChip(
                        label: const Text(
                          'Creators',
                          // 'Top 50 RJs',
                          style: TextStyle(color: Colors.white),
                        ),
                        selected: controller.chipSelectedIndex.value == 2,
                        selectedColor: Colors.white.withOpacity(0.2),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: controller.chipSelectedIndex.value == 2
                            ? const StadiumBorder(
                            side: BorderSide(
                                color: AppColors.firstColor, width: 0.20))
                            : null,
                        onSelected: (selected) {
                          controller.updateChipSelectedIndex(2);

                          // final args = ScreenArguments('Top 50 RJ\'S', ApiKeys.TOP_50_RJS_SUFFIX,  null);
                          /*final args = ScreenArguments(
                              'Creators', ApiKeys.TOP_50_RJS_SUFFIX, null);
                          Navigator.pushNamed(
                              context, AppRoutes.rjsListScreenVertical,
                              arguments: args);*/


                          final args = ScreenArguments(
                              'Creators', ApiKeys.TOP_50_RJS_SUFFIX, '',
                              filter: ''
                              );
                          Navigator.pushNamed(
                              context, AppRoutes.rjsListScreenVerticalPagination,
                              arguments: args);

                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ChoiceChip(
                        label: const Text(
                          'Trending Podcasts',
                          style: TextStyle(color: Colors.white),
                        ),
                        selected: controller.chipSelectedIndex.value == 1,
                        selectedColor: Colors.white.withOpacity(0.2),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: controller.chipSelectedIndex.value == 1
                            ? const StadiumBorder(
                            side: BorderSide(
                                color: AppColors.firstColor, width: 0.20))
                            : null,
                        onSelected: (selected) {
                          controller.updateChipSelectedIndex(1);

                          /*final args = ScreenArguments(
                              'Trending Podcasts',
                              ApiKeys.TRENDING_PODCAST_SUFFIX,
                              ApiKeys.getMobileUserQuery());
                          Navigator.pushNamed(
                              context, AppRoutes.podcastListScreenVertical,
                              arguments: args);*/

                          final args =
                          ScreenArguments('Trending Podcasts', ApiKeys.TRENDING_PODCAST_SUFFIX,'',filter: '');
                          Navigator.pushNamed(
                              context, AppRoutes.podcastListScreenVerticalPagination,
                              arguments: args);


                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ChoiceChip(
                        label: const Text(
                          'All Shows',
                          // 'Top 50 RJs',
                          style: TextStyle(color: Colors.white),
                        ),
                        selected: controller.chipSelectedIndex.value == 3,
                        selectedColor: Colors.white.withOpacity(0.2),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: controller.chipSelectedIndex.value == 3
                            ? const StadiumBorder(
                            side: BorderSide(
                                color: AppColors.firstColor, width: 0.20))
                            : null,
                        onSelected: (selected) {
                          controller.updateChipSelectedIndex(3);

                          /*final args = ScreenArguments(
                              'All Shows',
                              ApiKeys.LIST_SHOWS_SUFFIX,
                              ApiKeys.getShowsQuery(""));
                          Navigator.pushNamed(
                              context, AppRoutes.showsListScreenVertical,
                              arguments: args);*/

                          final args =
                          ScreenArguments('All Shows', ApiKeys.LIST_SHOWS_SUFFIX,'',filter: '');
                          Navigator.pushNamed(
                              context, AppRoutes.showsListScreenVerticalPagination,
                              arguments: args);

                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ChoiceChip(
                        label: const Text(
                          'JOJO',
                          style: TextStyle(color: Colors.white),
                        ),
                        selected: controller.chipSelectedIndex.value == 0,
                        selectedColor: Colors.white.withOpacity(0.2),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: controller.chipSelectedIndex.value == 0
                            ? const StadiumBorder(
                            side: BorderSide(
                                color: AppColors.firstColor, width: 0.20))
                            : null,
                        onSelected: (selected) {
                          controller.updateChipSelectedIndex(0);

                          /* final args = ScreenArguments(
                              'JOJO',
                              ApiKeys.CATOGEROY_PODCAST_SUFFIX,
                              ApiKeys.getCategoryQuery("JOJO", ""));
                          Navigator.pushNamed(
                              context, AppRoutes.podcastListScreenVertical,
                              arguments: args);*/

                          final args =
                          ScreenArguments('JOJO', ApiKeys.CATOGEROY_PODCAST_SUFFIX,'',filter: 'JOJO');
                          Navigator.pushNamed(
                              context, AppRoutes.podcastListScreenVerticalPagination,
                              arguments: args);

                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ChoiceChip(
                        label: const Text(
                          'Top Podcasts',
                          style: TextStyle(color: Colors.white),
                        ),
                        selected: controller.chipSelectedIndex.value == 3,
                        selectedColor: Colors.white.withOpacity(0.2),
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shape: controller.chipSelectedIndex.value == 3
                            ? const StadiumBorder(
                            side: BorderSide(
                                color: AppColors.firstColor, width: 0.20))
                            : null,
                        onSelected: (selected) {
                          controller.updateChipSelectedIndex(3);

                          /* final args = ScreenArguments('Top Podcasts',
                              ApiKeys.TOP_50_PODCAST_SUFFIX, null);
                          Navigator.pushNamed(
                              context, AppRoutes.podcastListScreenVertical,
                              arguments: args);*/

                          final args =
                          ScreenArguments('Top Podcasts', ApiKeys.TOP_50_PODCAST_SUFFIX,'',filter: '');
                          Navigator.pushNamed(
                              context, AppRoutes.podcastListScreenVerticalPagination,
                              arguments: args);

                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //const Categories(),
            const PaginationCategories(
              headerTitle: 'Browse by Categories',
              apiEndPoint: ApiKeys.CATEGORIES_SUFFIX_PAGINATION,
            ),
            const PaginationPodcasts(
              apiEndPoint: ApiKeys.TRENDING_PODCAST_SUFFIX,
              headerTitle: 'Trending Podcast',
              category: '',

            ),
            const PaginationPodcasts(
              apiEndPoint: ApiKeys.TOP_50_PODCAST_SUFFIX,
              headerTitle: 'Newly Added Podcasts',
              category: '',
            ),
            const PaginationRjs(
              apiEndPoint: ApiKeys.TOP_50_RJS_SUFFIX,
              headerTitle: 'Creators',
            ),
            const PaginationShows(
              headerTitle: 'Shows',
              apiEndPoint: ApiKeys.LIST_SHOWS_SUFFIX,
            ),

            /*PodcastListHorizontal(
              headerTitle: 'Trending Podcast',
              apiSuffix: ApiKeys.TRENDING_PODCAST_SUFFIX,
              query: ApiKeys.getMobileUserQuery(),
              callback: (){
                final args = ScreenArguments('Trending Podcasts', ApiKeys.TRENDING_PODCAST_SUFFIX,  ApiKeys.getMobileUserQuery());
                Navigator.pushNamed(context, AppRoutes.podcastListScreenVertical,arguments: args);
              },
            ),
             PodcastListHorizontal(
              headerTitle: 'Newly Added Podcasts',
              // headerTitle: 'Top 50 Podcast',
              apiSuffix: ApiKeys.TOP_50_PODCAST_SUFFIX,
              callback: (){

                final args = ScreenArguments('Newly Added Podcasts', ApiKeys.TOP_50_PODCAST_SUFFIX,  null);
                Navigator.pushNamed(context, AppRoutes.podcastListScreenVertical,arguments: args);

              },
            ),*/

            /* RjsListHorizontal(
              apiSuffix: ApiKeys.TOP_50_RJS_SUFFIX,
              query: ApiKeys.getMobileUserQuery(),
              headerTitle: 'Creators',
            ),*/

            /*showsListHorizontal(
              headerTitle: 'Shows',
              apiSuffix: ApiKeys.LIST_SHOWS_SUFFIX,
              // query: ApiKeys.getMobileUserQuery(),
              query: ApiKeys.getShowsQuery(""),
              callback: () {
                // final args = ScreenArguments('All Shows', ApiKeys.LIST_SHOWS_SUFFIX,  ApiKeys.getMobileUserQuery());
                final args = ScreenArguments('All Shows',
                    ApiKeys.LIST_SHOWS_SUFFIX, ApiKeys.getShowsQuery(""));
                Navigator.pushNamed(context, AppRoutes.showsListScreenVertical,
                    arguments: args);
              },
            ),*/

            const ListenedPodcasts(

            ),

            /*PodcastListHorizontal(
              headerTitle: 'Podcasts you listened',
              apiSuffix: ApiKeys.YOUR_LISTENED_PODCAST_SUFFIX,
              query: ApiKeys.getMobileUserQuery(),
              callback: () {
                final args = ScreenArguments(
                    'Podcasts you listened',
                    ApiKeys.YOUR_LISTENED_PODCAST_SUFFIX,
                    ApiKeys.getMobileUserQuery());
                Navigator.pushNamed(
                    context, AppRoutes.podcastListScreenVertical,
                    arguments: args);
              },
            ),*/


            const BottomCategoriesPagination(),

            // Obx(()=>controller.categories.isNotEmpty?Container(color: Colors.blue,width: 100,height: 100,):const SizedBox.shrink()),
            /*Obx(() => controller.categories.isNotEmpty
                ? populateCats(context)
                : const SizedBox.shrink()),*/

            /* PodcastListHorizontal(
              headerTitle: 'Comedy',
              apiSuffix: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
              query: ApiKeys.getCategoryQuery('Comedy',""),
              callback: (){

                final args = ScreenArguments('Comedy', ApiKeys.CATOGEROY_PODCAST_SUFFIX,  ApiKeys.getCategoryQuery('Comedy',""));
                Navigator.pushNamed(context, AppRoutes.podcastListScreenVertical,arguments: args);

              },
            ),
            PodcastListHorizontal(
              headerTitle: 'New & Politics',
              apiSuffix: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
              query: ApiKeys.getCategoryQuery('News',""),
              callback: (){

                final args = ScreenArguments('New & Politics', ApiKeys.CATOGEROY_PODCAST_SUFFIX,  ApiKeys.getCategoryQuery('News',""));
                Navigator.pushNamed(context, AppRoutes.podcastListScreenVertical,arguments: args);

              },
            ),
            PodcastListHorizontal(
              headerTitle: 'Society & Culture',
              apiSuffix: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
              query: ApiKeys.getCategoryQuery('Culture',""),
              callback: (){

                final args = ScreenArguments('Society & Culture', ApiKeys.CATOGEROY_PODCAST_SUFFIX,  ApiKeys.getCategoryQuery('Culture',""));
                Navigator.pushNamed(context, AppRoutes.podcastListScreenVertical,arguments: args);

              },
            ),*/
            const SizedBox(
              height: 200,
            )
          ],
        ),
      ),
    );

    /*return WillPopScope(
      onWillPop: () async =>
      !await keyOne.currentState!.maybePop(),
      child: Navigator(
          onGenerateRoute: (settings) {

            Widget page = dash_board_main();
            if (settings.name == 'Category'){
              page = LoginScreen();}

            return MaterialPageRoute(settings:settings,builder: (_) => page);
          }
      ),
    );*/
  }

  void pushScreen(BuildContext context, String s) {
    Navigator.of(context).pushNamed(AppRoutes.podcastListCategory,
        arguments: ScreenArguments(s, '', ''));
  }

  populateCats(context) {
    List<Widget> list = List.empty(growable: true);

    for (var i = 0; i < controller.categories.length; i++) {
      list.add(PaginationPodcasts(
        apiEndPoint: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
        headerTitle: controller.categories[i].name,
        category: controller.categories[i].name,
      ));

      /*list.add(PodcastListHorizontal(
        headerTitle: controller.categories[i].name,
        apiSuffix: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
        query: ApiKeys.getCategoryQuery(controller.categories[i].name!, ""),
        callback: () {
          final args = ScreenArguments(
              controller.categories[i].name!,
              ApiKeys.CATOGEROY_PODCAST_SUFFIX,
              ApiKeys.getCategoryQuery(controller.categories[i].name!, ""));
          Navigator.pushNamed(context, AppRoutes.podcastListScreenVertical,
              arguments: args);
        },
      ));*/
    }

    return Column(children: list);
  }

/*void postViewed(String podcastId) async {
    Map<String, String> query = {"podcast_id": podcastId, "mob_user_id": CommonNetworkApi().mobileUserId};

    await ApiService().postPodcastView(query);
  }*/

/*Map<String, dynamic> getUserQuery() {
    return {"user_id": "1"};
  }*/

/*Map<String, dynamic> getCategoryQuery(String s) {
    return {"category": s};
  }*/

}
