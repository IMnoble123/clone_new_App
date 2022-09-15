import 'package:get/get.dart';
import 'package:podcast_app/controllers/ad_controller.dart';
import 'package:podcast_app/controllers/auth_controller.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/controllers/profile_controller.dart';
import 'package:podcast_app/controllers/search_controller.dart';

class AppBinding extends Bindings{
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(SearchController());
    Get.put(MainController());
    Get.put(ProfileController());
    Get.put(PlayListController());
    Get.put(AdsController());
  }

}