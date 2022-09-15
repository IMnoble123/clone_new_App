import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_appcenter_bundle/flutter_appcenter_bundle.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/db/db.dart';
import 'package:podcast_app/extras/app_binding.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/keys.dart';
import 'package:podcast_app/extras/share_prefs.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/network/network_config.dart';
import 'package:podcast_app/screens/dummy_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> backgroundHandler(RemoteMessage message) async {

  try{


    print('SplashScreen background');

    print(message.data.toString());
    print(message.notification!.title);

  }catch(e){
    print('SplashScreen ${e.toString()}');
  }




}



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
 FirebaseMessaging.onBackgroundMessage(backgroundHandler);


  AppSharedPreference();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  ApiService().initDio(NetworkConfig.prod_baseUrl);
  // ApiService().initDio(NetworkConfig.qa_baseUrl);

  // await ApiService().generateToken();
  //ApiService().generateToken();

  //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //await SetupServiceLocator();

  JustAudioBackground.init(
    androidNotificationChannelId: 'com.tomtompodcast.app.channel.audio',
    androidNotificationChannelName: 'TomTom Podcast',
    androidNotificationOngoing: true,
  );

  loadAppCenter();

  final prefs = await SharedPreferences.getInstance();
  final showHome = prefs.getBool(AppKeys.SHOW_ON_BOARD) ?? false;
  final acceptedTC = prefs.getBool(AppConstants.ACCEPTED_TC) ?? false;
  AppConstants.age_restricted = prefs.getBool(AppConstants.AGE_RESTRICTED) ?? true;

  final userLoginedIn = prefs.getBool(AppConstants.IS_USER_LOGED_IN) ?? false;

  CommonNetworkApi().mobileUserId = prefs.getString(AppConstants.USER_ID) ?? '';
  print("Mobile User Id ${CommonNetworkApi().mobileUserId}");
  CommonNetworkApi().mobileUserName =
      prefs.getString(AppConstants.USER_Name) ?? 'Anonymous';

  TomTomDb().initDb();

  runApp(TomTomApp(
    showHome: showHome,
    userLogin: userLoginedIn,
    accptedTc: acceptedTC,
  ));

  WidgetsBinding.instance!.addObserver(_Handler());

}

class _Handler extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('App RESUMED');
    }else if (state == AppLifecycleState.detached) {

      try{

        Get.find<MainController>().tomtomPlayer.stop();
        Get.find<MainController>().tomtomPlayer.dispose();
      }catch(e){
        print('App detached with error ${e.toString()}');
      }

    } else {

      print('App PAUSED');

    }
  }
}

void loadAppCenter() async {
  await AppCenter.startAsync(
    appSecretAndroid: '0b4b5081-9543-4367-a671-aeeb07cdeba4',
    appSecretIOS: '4d85b2d3-3cbf-490d-984e-beeab99f889b',
    enableAnalytics: true,
    // Defaults to true
    enableCrashes: true,
    // Defaults to true
    enableDistribute: true,
    // Defaults to false
    usePrivateDistributeTrack: false,
    // Defaults to false
    disableAutomaticCheckForUpdate: false, // Defaults to false
  );
}

class TomTomApp extends StatefulWidget {
  final bool userLogin;
  final bool showHome;
  final bool accptedTc;

  static String podcastId = '';

  const TomTomApp(
      {Key? key,
      required this.showHome,
      required this.userLogin,
      required this.accptedTc})
      : super(key: key);

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_TomTomApp>()?.restartApp();
  }

  @override
  State<TomTomApp> createState() => _TomTomApp();
}

class _TomTomApp extends State<TomTomApp> {
  // cab86d0e941f49438c79d2f5f5e42e07

  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  StreamSubscription<ConnectivityResult>? subscription;
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  bool isDisconnected = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mySystemTheme = SystemUiOverlayStyle.light
        .copyWith(systemNavigationBarColor: Colors.black);

    SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

    return GetMaterialApp(
      key: key,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      title: 'TomTom Podcast',
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.red,
          splashColor: AppColors.firstColor.withOpacity(0.4),
          fontFamily: GoogleFonts.poppins().fontFamily,
          bottomSheetTheme:
              const BottomSheetThemeData(backgroundColor: Colors.transparent)),

      /* home: widget.userLogin
            ? const MainPage()
            : widget.showHome
                ? const LoginScreen()
                : const OnBoardingScreen(),*/

      home: DummyScreen(userLogin: widget.userLogin,),


    );

    /*return GetMaterialApp(
      key: key,
      title: 'TomTom Podcast',
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        splashColor: AppColors.firstColor.withOpacity(0.4),
        fontFamily: GoogleFonts.poppins().fontFamily
      ),

      home: widget.showHome?const LoginScreen():const OnBoardingScreen(),
      // home: const OnBoardingScreen(),
      // home: const SplashScreen(),
    );*/
  }
}
