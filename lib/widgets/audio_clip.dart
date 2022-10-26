
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/chat_controller.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/screens/slide_up_screen.dart';

class AudioClip extends StatefulWidget {
  final String audioUrl;

  const AudioClip({
    Key? key,
    required this.audioUrl,
  }) : super(key: key);

  @override
  State<AudioClip> createState() => _AudioClipState();
}

class _AudioClipState extends State<AudioClip> {
  AudioPlayer? audioPlayer;

  Duration totalDuration = Duration.zero;
  Duration currentDuration = Duration.zero;
  bool isPlaying = false;

  ChartController? controller ;//= Get.find<ChartController>();

  @override
  void initState() {
    audioPlayer = AudioPlayer();

    /*isPlaying = controller.playingAudio == widget.audioUrl;



    if (isPlaying) {
      totalDuration =controller.playingTotalDuration;
      currentDuration = controller.playingDuration;

     playAudio();

    }*/

    try{
      controller =  Get.find<ChartController>();
    }catch(e){
      controller = Get.put(ChartController());
    }

    initListener();

    super.initState();
  }

 /* void playAudio() async{

    for (var element in AudioPlayer.players.entries) {
      await element.value.stop();
    }

    Future.delayed(const Duration(milliseconds: 500), () async {
      print(widget.audioUrl);
      controller.playingAudio = widget.audioUrl;
      await audioPlayer?.play(
          widget.audioUrl.replaceAll(" ", "%20"),
          position: currentDuration);
    });

  }*/

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        isPlaying
            ? IconButton(
                onPressed: () {
                  audioPlayer?.pause();
                },
                icon: const Icon(
                  Icons.pause_circle_filled_outlined,
                  color: Colors.white,
                  size: 30,
                ))
            : IconButton(
                onPressed: () async {
                   var audioplayers = Get.find<MainController>().audioplayers;
                  for (var element in audioplayers){
                    await element.stop();}

                  Future.delayed(const Duration(seconds: 1), () async {
                    print(widget.audioUrl);
                    controller?.playingAudio = widget.audioUrl;
                    await audioPlayer?.play(DeviceFileSource(widget.audioUrl),
                          // widget.audioUrl,
                        // widget.audioUrl.replaceAll(" ", "%20"),
                        position: currentDuration);
                  });
                },
                icon: const Icon(
                  Icons.play_circle_fill_rounded,
                  color: Colors.white,
                  size: 30,
                )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: SliderTheme(
              data: const SliderThemeData(
                thumbShape: StrokeThumb(stroke: 2.0, thumbRadius: 10.0),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0),
              ),
              child: Slider(
                min: 0,
                max: totalDuration.inSeconds.toDouble(),
                value: currentDuration.inSeconds.toDouble(),
                onChanged: (s) {
                  setState(() {
                    currentDuration = Duration(seconds: s.toInt());
                    audioPlayer?.seek(currentDuration);
                  });
                },
                activeColor: Colors.white,
                inactiveColor: Colors.white.withOpacity(0.5),
                thumbColor: Colors.white,
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '${formatHHMMSS(currentDuration.inSeconds.toInt())} / ${formatHHMMSS(totalDuration.inSeconds.toInt())}',
            // '${formatHHMMSS(currentDuration.inSeconds.toInt())} ',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        )
        // Text('${formatHHMMSS(currentDuration.inSeconds.toInt())} / ${formatHHMMSS(totalDuration.inSeconds.toInt())}',style: const TextStyle(color: Colors.white,fontSize: 10),)
      ],
    );
  }

  void initListener() {
    audioPlayer?.onDurationChanged.listen((event) {
      if (mounted) {
        setState(() {
          totalDuration = event;
        });

        Future.delayed(const Duration(seconds: 3),(){
          if (isPlaying) {
            controller?.playingTotalDuration = event;
          }
        });
      }
    });

    audioPlayer?.onPositionChanged.listen((event) {
      if (mounted) {
        setState(() {
          currentDuration = event;
          if (isPlaying) {
            controller?.playingDuration = currentDuration;
          }
        });
      }
    });

    audioPlayer?.onPlayerStateChanged.listen((event) {
      print(event.name);

      if (event == PlayerState.playing) {
        isPlaying = true;

        Get.find<MainController>().tomtomPlayer.holdPlayer();
      } else {
        isPlaying = false;
        Get.find<MainController>().tomtomPlayer.releaseHold();
      }

      if (mounted) {
        setState(() {});
      }
    });

    audioPlayer?.onPlayerComplete.listen((event) {
      currentDuration = Duration.zero;
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  String formatHHMMSS(int seconds) {
    if (seconds != 0) {
      int hours = (seconds / 3600).truncate();
      seconds = (seconds % 3600).truncate();
      int minutes = (seconds / 60).truncate();

      String hoursStr = (hours).toString().padLeft(2, '0');
      String minutesStr = (minutes).toString().padLeft(2, '0');
      String secondsStr = (seconds % 60).toString().padLeft(2, '0');

      if (hours == 0) {
        return "$minutesStr:$secondsStr";
      }
      return "$hoursStr:$minutesStr:$secondsStr";
    } else {
      return "00:00";
    }
  }
}
