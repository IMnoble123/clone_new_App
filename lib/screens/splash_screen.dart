import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:podcast_app/controllers/auth_controller.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/main.dart';
import 'package:podcast_app/screens/home_screen.dart';
import 'package:podcast_app/services/local_notification_service.dart';
import 'package:podcast_app/services/push_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback callback;

  const SplashScreen({Key? key, required this.callback}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      body: Stack(
        children: [
          startAnimation
              ? Lottie.asset('images/splash_animation.json',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  repeat: false,
                  reverse: false,
                  animate: false,
                  controller: lottieController, onLoaded: (composition) {
                  lottieController.duration = composition.duration;
                  lottieController.forward();
                })
              : Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ],
      ),
    );
  }

  AudioCache audioCache = AudioCache();
  bool startAnimation = false;

  @override
  void initState() {
    super.initState();

    LocalNotificationService.initialize(context);

    PushNotifications.initPushNotifications(context);

    lottieController = AnimationController(
      vsync: this,
    );

    loadFiles();




  }

  @override
  void dispose() {
    audioCache.clearAll();
    lottieController.dispose();
    super.dispose();
  }

  void loadFiles() async {
    /*final uri = await audioCache.load('audio/splash_audio.mp4');
    audioCache.play(uri.path, mode: PlayerMode.LOW_LATENCY);
*/

    await audioCache.play('audio/splash_audio_2.wav',
        mode: PlayerMode.MEDIA_PLAYER);
    // mode: PlayerMode.MEDIA_PLAYER);

    setState(() {
      startAnimation = true;
    });

    lottieController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        print('SplashScreen - Anim completed');
        lottieController.reset();
        await audioCache.clearAll();

        widget.callback();
      }
    });
  }


}
