import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:podcast_app/extras/app_colors.dart';
import '../main.dart';
import '../network/common_network_calls.dart';
import '../screens/main/main_page.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {});

    InitializationSettings initializationSettings = InitializationSettings(
        iOS: initializationSettingsIOS,
        android: const AndroidInitializationSettings("@drawable/app_icon_not"));

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? s) async {
      if (s != null) {
        TomTomApp.podcastId = s;
        if (CommonNetworkApi().mobileUserId.toString().trim().isNotEmpty) {
          MainPage.playSelectedPodcast(TomTomApp.podcastId);
        }
      }
    });

    requestIOSPermissions();
  }

  static void requestIOSPermissions() {
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  static void display(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        "tomtom",
        "TomTom channel",
        channelDescription: "This is TOMTOM channel",
        importance: Importance.max,
        color: AppColors.firstColor,
        priority: Priority.high,
      ));

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['podcastId'],
      );
    } on Exception catch (e) {
      log(e.toString());
    }
  }
}
