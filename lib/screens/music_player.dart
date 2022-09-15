import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast_app/models/search_response.dart';

import 'audio_recorder.dart';

class MusicPlayerScreen extends StatefulWidget {
  final Result? podItem;

  const MusicPlayerScreen({Key? key, this.podItem}) : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  final player = AudioPlayer();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    //loadAudio();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      appBar: AppBar(
        title: Text(widget.podItem!.titleOriginal!),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  clipBehavior: Clip.hardEdge,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.podItem!.image!,
                    // 'https://stilearning.com/vision/assets/globals/img/dummy/img-10.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RawMaterialButton(
                    onPressed: () {},
                    padding: const EdgeInsets.all(8.0),
                    shape: CircleBorder(),
                    elevation: 10.0,
                    fillColor: Colors.white,
                    child: const Icon(
                      Icons.fast_rewind_rounded,
                      size: 40,
                    ),
                  ),
                  isLoading
                      ? CircularProgressIndicator()
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
                          shape: CircleBorder(),
                          elevation: 10.0,
                          fillColor: Colors.white,
                          child: Icon(
                            player.playing
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 40,
                          ),
                        ),
                  RawMaterialButton(
                    onPressed: () {},
                    padding: const EdgeInsets.all(8.0),
                    shape: const CircleBorder(),
                    elevation: 10.0,
                    fillColor: Colors.white,
                    child: const Icon(
                      Icons.fast_forward_rounded,
                      size: 40,
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ));
  }

  void loadAudio() async {
    setState(() {
      isLoading = true;
    });
    await player.setUrl(widget.podItem!.audio!).then((value) {
      isLoading = false;
      setState(() {});
      player.play();
      print(value);
    });
  }

  /*@override
  void dispose() {
    super.dispose();
    player.dispose();
  }*/
}
