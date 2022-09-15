import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicControls extends StatefulWidget {
  final String path;

  const MusicControls({Key? key, required this.path}) : super(key: key);

  @override
  _MusicControlsState createState() => _MusicControlsState();
}

class _MusicControlsState extends State<MusicControls> {
  final player = AudioPlayer();

  bool isLoading = false;
  bool isCompleted = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    player.playerStateStream.listen((event) {
      switch (event.processingState) {
        case ProcessingState.loading:
          break;
        case ProcessingState.completed:
          isCompleted = true;
          setState(() {

          });
          break;
        case ProcessingState.idle:
          // TODO: Handle this case.
          break;
        case ProcessingState.buffering:
          // TODO: Handle this case.
          break;
        case ProcessingState.ready:
          // TODO: Handle this case.
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isCompleted
                ? RawMaterialButton(
                    onPressed: () {
                      isCompleted = false;
                      player.seek(const Duration(seconds: 1));
                      player.play();
                      setState(() {});
                    },
                    padding: const EdgeInsets.all(8.0),
                    shape: const CircleBorder(),
                    elevation: 10.0,
                    fillColor: Colors.white,
                    child: const Icon(
                      Icons.refresh,
                      size: 40,
                    ),
                  )
                : RawMaterialButton(
                    onPressed: () {
                      if (player.playing) {
                        player.pause();
                        setState(() {});
                      } else if (player.position.inSeconds > 0) {
                        player.play();
                        setState(() {});
                      } else {
                        loadAudio();
                      }
                    },
                    padding: const EdgeInsets.all(8.0),
                    shape: const CircleBorder(),
                    elevation: 10.0,
                    fillColor: Colors.white,
                    child: Icon(
                      player.playing
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 40,
                    ),
                  )
          ],
        )
      ],
    );
  }

  void loadAudio() async {
    setState(() {
      isLoading = true;
    });
    // await player.setUrl(widget.podItem!.audio!).then((value) {
    await player.setFilePath(Uri.parse(widget.path).path).then((value) {
      isLoading = false;
      setState(() {});
      player.play();
      print(value);
    });
  }
}
