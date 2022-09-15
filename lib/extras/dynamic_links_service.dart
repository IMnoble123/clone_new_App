import 'dart:convert';

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
  /*static Future<String> createDynamicLink(Podcast podcast) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.packageName);
    String uriPrefix = "https://open.tomtompodcast.com";

    final String data = jsonEncode(podcast);

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: uriPrefix,
      link: Uri.parse('https://www.tomtompodcast.com?data=$data'),

      androidParameters: AndroidParameters(
        // packageName: packageInfo.packageName,
        packageName: "app.tomtompodcast.com",
        minimumVersion: 21,
      ),

      iosParameters: IosParameters(
          bundleId: "app.tomtompodcast.com",
          minimumVersion: packageInfo.version,
          appStoreId: '123456789'),

      navigationInfoParameters: NavigationInfoParameters(
          forcedRedirectEnabled: true
      ),

      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
      ),

      //iosParameters: IOSParameters(bundleId: packageInfo.packageName,minimumVersion: packageInfo.version,appStoreId: '123456789'),

      */ /* googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),*/ /*

      */ /*itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),*/ /*
      socialMetaTagParameters: SocialMetaTagParameters(
          title: 'TomTom Podcast',
          description: 'New podcast released',
          imageUrl: Uri.parse('https://images.pexels.com/photos/3841338/pexels-photo-3841338.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260')),
          // imageUrl: Uri.parse(podcast.imagepath!)),
    );

    // final Uri dynamicUrl = await parameters.buildUrl();

     final ShortDynamicLink shortDynamicLink = await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink.shortUrl;
    return shortUrl.toString();

    */ /*final Uri uri = await parameters.buildUrl();
    return uri.toString();*/ /*
  }*/

  static FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  static Future<String> createRjDynamicLink(RjItem rjItem) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.packageName);
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
    print(packageInfo.packageName);
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
      // imageUrl: Uri.parse('https://4.img-dpreview.com/files/p/E~TS590x0~articles/3925134721/0266554465.jpeg')),
      // imageUrl: Uri.parse(podcast.imagepath!)),
    );

    //Uri uri =await dynamicLinks.buildLink(parameters);

    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    Uri uri = shortLink.shortUrl;

    return uri.toString();
  }

  static void initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      _handleDynamicLink(dynamicLinkData);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
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

  static _handleDynamicLink(PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      print(deepLink);
      if (deepLink.toString().contains('rjId')) {
        final rjId = jsonDecode(deepLink.queryParameters['rjId']!);

        if (rjId != null) {
          gotoRjProfile(rjId.toString());
        }
      } else {
        final Podcast podcast =
            Podcast.fromJson(jsonDecode(deepLink.queryParameters['podcast']!));

        if (podcast != null) {
          if (podcast != null) {
            print(podcast.toJson().toString());
            Get.find<MainController>()
                .tomtomPlayer
                .addAllPodcasts(List.filled(1, podcast), 0);
            Get.find<MainController>().togglePanel();

            CommonNetworkApi().postViewed(podcast.podcastId!);

            //navigateKey.currentState.pushNamed(PostSinglePage.routeName, arguments: post);
          }
        }
      }
    }

    /*if (deepLink == null) {
      return;
    }

    if (deepLink.pathSegments.contains('refer')) {
      var title = deepLink.queryParameters['code'];
      if (title != null) {
        print("refercode=$title");
      }
    }*/
  }

  static void gotoRjProfile(rjId) async {
    final responseData = await ApiService()
        .postData(ApiKeys.RJ_BYID_SUFFIX, ApiKeys.getRjByRjIdQuery(rjId));

    RjResponse response = RjResponse.fromJson(responseData);

    if (response.status == "Success") {
      RjItem rjItem = response.rjItems![0];

      if (rjItem != null) {

        if (Get.find<MainController>().panelController.isPanelOpen) {
          Get.find<MainController>().panelController.close();
        }


        Navigator.pushNamed(
            MainPage.activeContext!, AppRoutes.podcastDetailsScreen,
            arguments: rjItem);
      }
    }
  }
}
