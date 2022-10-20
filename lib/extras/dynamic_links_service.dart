import 'dart:convert';
import 'dart:developer';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import '../network/api_keys.dart';

class DynamicLinksService {
  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  static Future<String> createRjDynamicLink(RjItem rjItem) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    log(packageInfo.packageName);
    String uriPrefix = "https://tomtompodcast.page.link";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse('https://www.tomtompodcast.com?rjId=${rjItem.rjUserId}'),
      androidParameters: const AndroidParameters(
        // packageName: packageInfo.packageName,
        packageName: "app.tomtompodcast.com",
      ),
      iosParameters: const IOSParameters(
          bundleId: "app.tomtompodcast.com", appStoreId: ''),
      navigationInfoParameters:
          const NavigationInfoParameters(forcedRedirectEnabled: true),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: rjItem.rjName!,
          description: rjItem.aboutme ?? '',
          imageUrl: Uri.parse(rjItem.profileImage!)),
    );

    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    Uri uri = shortLink.shortUrl;

    return uri.toString();
  }

  static Future<String> createDynamicLink(Podcast podcast) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    log(packageInfo.packageName);
    String uriPrefix = "https://tomtompodcast.page.link";
    // String uriPrefix = "https://open.tomtompodcast.com";

    final String data = jsonEncode(podcast);

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse('https://www.tomtompodcast.com?podcast=$data'),
      // link: Uri.parse('https://www.google.com/'),

      // longDynamicLink: Uri.parse('$uriPrefix?link=https://www.google.com/'),

      androidParameters: const AndroidParameters(
        // packageName: packageInfo.packageName,
        packageName: "app.tomtompodcast.com",
      ),

      iosParameters: const IOSParameters(
          bundleId: "app.tomtompodcast.com", appStoreId: ''),

      navigationInfoParameters:
          const NavigationInfoParameters(forcedRedirectEnabled: true),

      socialMetaTagParameters: SocialMetaTagParameters(
          title: podcast.podcastName!,
          description: podcast.description!,
          imageUrl: Uri.parse(podcast.imagepath!)),
    );

    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    Uri uri = shortLink.shortUrl;
    return uri.toString();
  }

  static void initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      _handleDynamicLink(dynamicLinkData);
    }).onError((error) {
      log('onLink error');
      log(error.message);
    });
  }

  static _handleDynamicLink(PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      log(deepLink.toString());
      if (deepLink.toString().contains('rjId')) {
        final rjId = jsonDecode(deepLink.queryParameters['rjId']!);

        if (rjId != null) {
          gotoRjProfile(rjId.toString());
        }
      } else {
        final Podcast podcast =
            Podcast.fromJson(jsonDecode(deepLink.queryParameters['podcast']!));

        log(podcast.toJson().toString());
        Get.find<MainController>()
            .tomtomPlayer
            .addAllPodcasts(List.filled(1, podcast), 0);
        Get.find<MainController>().togglePanel();

        CommonNetworkApi().postViewed(podcast.podcastId!);
      }
    }
  }

  static void gotoRjProfile(rjId) async {
    final responseData = await ApiService()
        .postData(ApiKeys.RJ_BYID_SUFFIX, ApiKeys.getRjByRjIdQuery(rjId));

    RjResponse response = RjResponse.fromJson(responseData);

    if (response.status == "Success") {
      RjItem rjItem = response.rjItems![0];

      if (Get.find<MainController>().panelController.isPanelOpen) {
        Get.find<MainController>().panelController.close();
      }

      Navigator.pushNamed(
          MainPage.activeContext!, AppRoutes.podcastDetailsScreen,
          arguments: rjItem);
    }
  }
}

  /*static void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDynamicLink(data!);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      _handleDynamicLink(dynamicLink!);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }*/

  /*if (deepLink == null) {
      return;
    }

    if (deepLink.pathSegments.contains('refer')) {
      var title = deepLink.queryParameters['code'];
      if (title != null) {
        print("refercode=$title");
      }
    }*/
