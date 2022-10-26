import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService();
  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> intialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/app_icon_not');

    DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final InitializationSettings settings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: darwinInitializationSettings);

    await _localNotificationService.initialize(settings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("tomtom", "tomtom channel",
            channelDescription: 'tom-tom channel',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            color: AppColors.firstColor);
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showScheuledNotification({
    required int id,
    required String title,
    required String body,
    required int seconds,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          DateTime.now().add(Duration(seconds: seconds)),
          tz.local,
        ),
        details,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void onDidReceiveNotificationResponse(NotificationResponse details) {}
}



//  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize(BuildContext context) {
//     final IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings(
//             requestAlertPermission: false,
//             requestBadgePermission: false,
//             requestSoundPermission: false,
//             onDidReceiveLocalNotification: (
//               int id,
//               String? title,
//               String? body,
//               String? payload,
//             ) async {});

//     InitializationSettings initializationSettings = InitializationSettings(
//         iOS: initializationSettingsIOS,
//         android: const AndroidInitializationSettings("@drawable/app_icon_not"));

//     _notificationsPlugin.initialize(initializationSettings,
//         onSelectNotification: (String? s) async {
//       if (s != null) {
//         TomTomApp.podcastId = s;
//         if (CommonNetworkApi().mobileUserId.toString().trim().isNotEmpty) {
//           MainPage.playSelectedPodcast(TomTomApp.podcastId);
//         }
//       }
//     });

//     requestIOSPermissions();
//   }

//   static void requestIOSPermissions() {
//     _notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//   }


  // static void display(RemoteMessage message) async {
  //   try {
  //     final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  //     const NotificationDetails notificationDetails = NotificationDetails(
  //         android: AndroidNotificationDetails(
  //       "tomtom",
  //       "TomTom channel",
  //       channelDescription: "This is TOMTOM channel",
  //       importance: Importance.max,
  //       color: AppColors.firstColor,
  //       priority: Priority.high,
  //     ));

  //     await _notificationsPlugin.show(
  //       id,
  //       message.notification!.title,
  //       message.notification!.body,
  //       notificationDetails,
  //       payload: message.data['podcastId'],
  //     );
  //   } on Exception catch (e) {
  //     log(e.toString());
  //   }
  // }

 
 
