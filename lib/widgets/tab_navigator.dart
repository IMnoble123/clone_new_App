import 'package:flutter/material.dart';
import 'package:podcast_app/components/pagination_categories_vertical.dart';
import 'package:podcast_app/components/pagination_podcast_vertical.dart';
import 'package:podcast_app/components/pagination_rjs_vertical.dart';
import 'package:podcast_app/components/shows/shows_pagination_vertical.dart';
import 'package:podcast_app/components/shows/shows_podcasts_vertical.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/screens/dash_board.dart';
import 'package:podcast_app/screens/login/login_screen.dart';
import 'package:podcast_app/screens/main/category_details_screen.dart';
import 'package:podcast_app/screens/modules/podcast_list_vertical.dart';
import 'package:podcast_app/screens/modules/rjs_list_vertical.dart';
import 'package:podcast_app/screens/modules/shows_list_vertical.dart';
import 'package:podcast_app/screens/playlist/play_list_screen.dart';
import 'package:podcast_app/screens/profile/logout_screen.dart';
import 'package:podcast_app/screens/profile/notifications_screen.dart';
import 'package:podcast_app/screens/profile/profile_screen.dart';
import 'package:podcast_app/screens/profile/account_screen.dart';
import 'package:podcast_app/screens/sub_screens/browse_categories.dart';
import 'package:podcast_app/screens/profile/edit_profile_screen.dart';
import 'package:podcast_app/screens/sub_screens/podcast_details_screen.dart';
import 'package:podcast_app/screens/sub_screens/podcast_home_by_cat.dart';
import 'package:podcast_app/screens/sub_screens/podcast_list_screen.dart';
import 'package:podcast_app/screens/sub_screens/rjs_list_screen.dart';
import 'package:podcast_app/screens/profile/settings_screen.dart';
import 'package:podcast_app/screens/tom_tom_screen.dart';
import 'package:podcast_app/widgets/bottom_navigation.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final String? name;

  const TabNavigator({
    Key? key,
    this.navigatorKey,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (name == 'playList') {
      child = const PlayListScreen();
    } else if (name == 'tomTom') {
      child = const TomTomScreen();
    } else if (name == 'profile') {
      child = const ProfileScreen();
    } else {
      child = const DashBoardScreen();
    }

    return Navigator(
        key: navigatorKey,
        onGenerateRoute: (routeSettings) {
          print(routeSettings.name);
          if (routeSettings.name == AppRoutes.category) {
            child = const LoginScreen();
          } else if (routeSettings.name == AppRoutes.browseCategories) {
            child = const BrowseCategoriesScreen();
          } else if (routeSettings.name ==
              AppRoutes.browseCategoriesPagination) {
            child = const PaginationCategoriesVertical();
          } else if (routeSettings.name == AppRoutes.podcastListCategory) {
            final args = routeSettings.arguments as ScreenArguments;
            child = CategoryDetailsScreen(
              categoryName: args.title,
              categoryKey: args.titleKey,
            );
            /* child = PodcastHomeBycategory(
              title: args.title,
              titleKey: args.titleKey,
            );*/
          } else if (routeSettings.name == AppRoutes.podcastDetailsScreen) {
            final rjItem = routeSettings.arguments as RjItem;
            child = PodcastDetailsScreen(rjItem);
          } else if (routeSettings.name == AppRoutes.editProfileScreen) {
            child = const EditProfileScree();
          } else if (routeSettings.name == AppRoutes.accountProfileScreen) {
            child = const AccountScreen();
          } else if (routeSettings.name == AppRoutes.settingsProfileScreen) {
            child = const SettingsScreen();
          } else if (routeSettings.name ==
              AppRoutes.notificationsProfileScreen) {
            child = const NotificationsScreen();
          } else if (routeSettings.name == AppRoutes.logoutProfileScreen) {
            child = const LogOutScreen();
          } else if (routeSettings.name == AppRoutes.podcastListScreen) {
            final args = routeSettings.arguments as ScreenArguments;
            child = PodcastListScreen(
                podcasts: args.anyObject as List<Podcast>, title: args.title);
          } else if (routeSettings.name ==
              AppRoutes.podcastListScreenVertical) {
            final args = routeSettings.arguments as ScreenArguments;
            child = PodcastListVertical(
              query: args.anyObject != null
                  ? args.anyObject as Map<String, dynamic>
                  : {},
              apiSuffix: args.titleKey,
              title: args.title,
              filter: args.filter,
            );
          } else if (routeSettings.name == AppRoutes.rjsListScreenVertical) {
            final args = routeSettings.arguments as ScreenArguments;
            child = RjsListVertical(
                query: args.anyObject != null
                    ? args.anyObject as Map<String, dynamic>
                    : {},
                apiSuffix: args.titleKey,
                title: args.title);
          } else if (routeSettings.name == AppRoutes.rjsListScreen) {
            final args = routeSettings.arguments as ScreenArguments;
            child = RjsListScreen(
                rjItems: args.anyObject as List<RjItem>, title: args.title);
          } else if (routeSettings.name == AppRoutes.showsListScreenVertical) {
            final args = routeSettings.arguments as ScreenArguments;
            child = ShowsListVertical(
              query: args.anyObject != null
                  ? args.anyObject as Map<String, dynamic>
                  : {},
              apiSuffix: args.titleKey,
              title: args.title,
            );
          } else if (routeSettings.name ==
              AppRoutes.podcastListScreenVerticalPagination) {
            final args = routeSettings.arguments as ScreenArguments;
            child = PaginationPodcastsVertical(
              headerTitle: args.title,
              apiEndPoint: args.titleKey,
              category: args.filter,
            );
          } else if (routeSettings.name ==
              AppRoutes.showsListScreenVerticalPagination) {
            final args = routeSettings.arguments as ScreenArguments;
            child = PaginationShowsVertical(
              headerTitle: args.title,
              apiEndPoint: args.titleKey,
              category: args.filter,
            );
          } else if (routeSettings.name ==
              AppRoutes.rjsListScreenVerticalPagination) {
            final args = routeSettings.arguments as ScreenArguments;
            child = PaginationRjsVertical(
              headerTitle: args.title,
              apiEndPoint: args.titleKey,
              category: args.filter,
            );
          } else if (routeSettings.name ==
              AppRoutes.showPodcastsScreenVerticalPagination) {
            final args = routeSettings.arguments as ScreenArguments;
            child = PaginationShowsPodcastsVertical(
              headerTitle: args.title,
              apiEndPoint: args.titleKey,
              showId: args.filter,
            );
          }

          return MaterialPageRoute(builder: (context) => child);
        });
  }
}
