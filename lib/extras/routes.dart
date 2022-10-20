import 'package:flutter/material.dart';
import 'screen_args.dart';

class AppRoutes {
  static const String onBoard = 'onBoard';
  static const String login = 'login';
  static const String register = 'register';
  static const String home = 'home';
  static const String dashboard = 'dashBoard';
  static const String playList = 'playList';
  static const String tomTom = 'tomTom';
  static const String profile = 'profile';
  static const String category = 'category';
  static const String browseCategories = 'browseCategories';
  static const String podcastListCategory = 'podcastListByCategory';
  static const String podcastDetailsScreen = 'podcastDetailsScreen';
  static const String editProfileScreen = 'editProfileScreen';
  static const String accountProfileScreen = 'accountProfileScreen';
  static const String settingsProfileScreen = 'settingsProfileScreen';
  static const String notificationsProfileScreen = 'notificationsProfileScreen';
  static const String logoutProfileScreen = 'logoutProfileScreen';
  static const String podcastListScreen = 'podcastListScreen';
  static const String podcastListScreenVertical = 'verticalPodcasts';
  static const String rjsListScreenVertical = 'verticalRjs';
  static const String rjsListScreen = 'rjsListScreen';
  static const String videoScreen = 'videoScreen';
  static const String showsListScreenVertical = 'verticalShows';
  static const String podcastListScreenVerticalPagination = 'verticalPodcastsPagination';
  static const String rjsListScreenVerticalPagination = 'rjsVerticalPagination';
  static const String showsListScreenVerticalPagination = 'showsVerticalPagination';
  static const String showPodcastsScreenVerticalPagination = 'showPodcastsVerticalPagination';
  static const String browseCategoriesPagination = 'browseCategoriesPagination';


  static void pushScreenByArgs(BuildContext context, String title,String key) {
    Navigator.of(context).pushNamed(AppRoutes.podcastListCategory,
        arguments: ScreenArguments(title, key,''));
  }



}
