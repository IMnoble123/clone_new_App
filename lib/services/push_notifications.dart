import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/share_prefs.dart';
import 'package:podcast_app/main.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/services/local_notification_service.dart';

class PushNotifications {

  static void initPushNotifications(BuildContext context) async{

    // await Firebase.initializeApp();

    FirebaseMessaging.instance.getToken().then((value) {
      print("Token : $value");
      AppSharedPreference().saveStringData(AppConstants.FCM_TOKEN, value ?? '');
    });


    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );




    if (settings.authorizationStatus == AuthorizationStatus.authorized) {




      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {

          Future.delayed(const Duration(seconds: 10),(){

            TomTomApp.podcastId = message.data['podcastId'];
            if (CommonNetworkApi().mobileUserId
                .toString()
                .trim()
                .isNotEmpty) {
              MainPage.playSelectedPodcast(TomTomApp.podcastId);
            }

          });

        }
      });

      ///forground work
      FirebaseMessaging.onMessage.listen((message) {
        if (message.notification != null) {
          print(message.notification!.body);
          print(message.notification!.title);
        }

        // LocalNotificationService.display(message);
      });

      ///When the app is in background but opened and user taps
      ///on the notification
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        TomTomApp.podcastId = message.data['podcastId'];
        if (CommonNetworkApi().mobileUserId
            .toString()
            .trim()
            .isNotEmpty) {
          MainPage.playSelectedPodcast(TomTomApp.podcastId);
        }
      });

    }

  }

}