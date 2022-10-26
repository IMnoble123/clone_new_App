import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:podcast_app/services/local_notification_service.dart';
import 'package:podcast_app/services/push_notifications.dart';

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
  late final LocalNotificationService service;

  @override
  void initState() {
    super.initState();
    //  LocalNotificationService.initialize(context);
    service = LocalNotificationService();
    service.intialize();
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
    await AudioPlayer().play(AssetSource('audio/splash_audio_2.wav'),
        mode: PlayerMode.mediaPlayer);
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
  /*final uri = await audioCache.load('audio/splash_audio.mp4');
    audioCache.play(uri.path, mode: PlayerMode.LOW_LATENCY);
*/
