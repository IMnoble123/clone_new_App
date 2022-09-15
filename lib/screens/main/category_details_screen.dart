import 'package:flutter/material.dart';
import 'package:podcast_app/components/listened_podcasts.dart';
import 'package:podcast_app/components/pagination_podcasts.dart';
import 'package:podcast_app/components/shows/shows_pagination.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/screens/modules/podcasts_list_horizontal.dart';
import 'package:podcast_app/screens/modules/rjs_list_horizontal.dart';
import 'package:podcast_app/screens/modules/shows_list_horizontal.dart';

import '../../components/pagination_rjs.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final String categoryName;
  final String categoryKey;

  const CategoryDetailsScreen(
      {Key? key, required this.categoryName, required this.categoryKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
              colors: [
                Colors.red.withOpacity(0.5),
                Colors.black.withOpacity(0.5)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.5])),
      /*decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover)),*/
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        appBar: AppBar(
          title: Text(
            categoryName,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /*showsListHorizontal(
                headerTitle: 'Shows',
                apiSuffix: ApiKeys.LIST_SHOWS_SUFFIX,
                // query: ApiKeys.getMobileUserQuery(),
                query: ApiKeys.getShowsQuery(categoryName),
                callback: () {
                  // final args = ScreenArguments('All Shows', ApiKeys.LIST_SHOWS_SUFFIX,  ApiKeys.getMobileUserQuery());
                  final args = ScreenArguments(
                      'All Shows',
                      ApiKeys.LIST_SHOWS_SUFFIX,
                      ApiKeys.getShowsQuery(categoryName));
                  Navigator.pushNamed(
                      context, AppRoutes.showsListScreenVertical,
                      arguments: args);
                },
              ),*/
               PaginationShows(
                headerTitle: 'Shows',
                apiEndPoint: ApiKeys.LIST_SHOWS_SUFFIX,
                category: categoryKey,
              ),
              PaginationPodcasts(
                // apiEndPoint: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
                apiEndPoint: ApiKeys.TRENDING_PODCAST_SUFFIX,
                headerTitle: 'Trending Podcasts',
                category: categoryKey,
              ),
               PaginationPodcasts(
                apiEndPoint: ApiKeys.TOP_50_PODCAST_SUFFIX,
                headerTitle: 'Newly Added Podcasts',
                category: categoryKey,
              ),
              PaginationRjs(
                apiEndPoint: ApiKeys.TOP_50_RJS_SUFFIX,
                headerTitle: 'Creators',
                category: categoryKey,
              ),
              /*PodcastListHorizontal(
                apiSuffix: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
                query: ApiKeys.getCategoryQuery(categoryKey, 'trending'),
                headerTitle: 'Trending Podcasts',
                callback: () {
                  final args = ScreenArguments(
                      'Trending Podcasts',
                      ApiKeys.CATOGEROY_PODCAST_SUFFIX,
                      ApiKeys.getCategoryQuery(categoryKey, 'trending'));
                  Navigator.pushNamed(
                      context, AppRoutes.podcastListScreenVertical,
                      arguments: args);
                },
              ),
              PodcastListHorizontal(
                apiSuffix: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
                headerTitle: 'Newly Added Podcasts',
                query: ApiKeys.getCategoryQuery(categoryKey, 'top'),
                callback: () {
                  final args = ScreenArguments(
                      'Newly Added Podcasts',
                      ApiKeys.CATOGEROY_PODCAST_SUFFIX,
                      ApiKeys.getCategoryQuery(categoryKey, 'top'));
                  Navigator.pushNamed(
                      context, AppRoutes.podcastListScreenVertical,
                      arguments: args);
                },
              ),*/

              /*RjsListHorizontal(
                apiSuffix: ApiKeys.TOP_50_RJS_SUFFIX,
                headerTitle: 'Creators',
                query: ApiKeys.getCatQuery(categoryName),
              ),*/


               ListenedPodcasts(
                category: categoryKey,
              ),

              /*PodcastListHorizontal(
                headerTitle: 'Podcasts you listened',
                apiSuffix: ApiKeys.YOUR_LISTENED_PODCAST_SUFFIX,
                query: ApiKeys.getCatQuery(categoryName),
                filter: categoryKey,
                callback: () {
                  final args = ScreenArguments(
                      'Podcasts you listened',
                      ApiKeys.YOUR_LISTENED_PODCAST_SUFFIX,
                      ApiKeys.getCatQuery(categoryName),
                      filter: categoryKey);
                  Navigator.pushNamed(
                      context, AppRoutes.podcastListScreenVertical,
                      arguments: args);
                },
              ),*/

              Visibility(
                visible: false,
                child: PodcastListHorizontal(
                  apiSuffix: ApiKeys.WHERE_U_STOPED_SUFFIX,
                  headerTitle: 'Continue from where you stoped',
                  callback: () {},
                ),
              ),
              /*PodcastListHorizontal(
                apiSuffix: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
                headerTitle: 'All Podcasts',
                query: ApiKeys.getCategoryQuery(categoryKey, 'top'),
                callback: () {
                  final args = ScreenArguments(
                      'All Podcasts',
                      ApiKeys.CATOGEROY_PODCAST_SUFFIX,
                      ApiKeys.getCategoryQuery(categoryKey, 'top'));
                  Navigator.pushNamed(
                      context, AppRoutes.podcastListScreenVertical,
                      arguments: args);
                },
              ),*/

              PaginationPodcasts(
                // apiEndPoint: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
                apiEndPoint: ApiKeys.CATOGEROY_PODCAST_SUFFIX,
                headerTitle: 'All Podcasts',
                category: categoryKey,
              ),


              const SizedBox(
                height: 200,
              )
            ],
          ),
        ),
      ),
    );
  }
}
