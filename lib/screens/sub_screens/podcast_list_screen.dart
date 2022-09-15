import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/widgets/song_info_tile.dart';

class PodcastListScreen extends StatelessWidget {
  final String title;
  final List<Podcast> podcasts;

  const PodcastListScreen(
      {Key? key, required this.podcasts, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover,opacity: 0.6)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 0.0,bottom: 150.0),
          child: ListView.separated(
              itemBuilder: (c, i) {
                return SongInfoTile(
                  podcast: podcasts[i],
                  callback: (){
                    Get.find<MainController>().tomtomPlayer.addAllPodcasts(podcasts,i);
                  },
                  playAll: (){
                    print('playAll');
                    Get.find<MainController>().tomtomPlayer.addAllPodcasts(podcasts,0);
                  },
                );
              },
              separatorBuilder: (c, i) {
                return const Divider();
              },
              itemCount: podcasts.length),
        ),

      ),
    );
  }
}
