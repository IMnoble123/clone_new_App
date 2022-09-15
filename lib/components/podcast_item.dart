import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/models/response/podcast_response.dart';

import '../extras/app_colors.dart';
import '../extras/constants.dart';
import '../network/common_network_calls.dart';

class PodcastItem extends StatelessWidget {
  final double cardWidth;
  final Podcast podcast;
  final VoidCallback? callback;
  const PodcastItem({Key? key, required this.cardWidth, required this.podcast, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Stack(
        children: [
          SizedBox(
            width: cardWidth,
            //height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                      BorderRadius.circular(8.0),

                       child: CachedNetworkImage(
                                          imageUrl: podcast
                                                      .imagepath!
                                                      .isNotEmpty &&
                                                  !podcast
                                                      .imagepath!
                                                      .contains(".jfif")
                                              ? podcast.imagepath!
                                              : AppConstants.dummyPic,
                                          width: cardWidth,
                                          height: cardWidth,
                                          memCacheWidth: 2*cardWidth.toInt(),
                                          memCacheHeight: 2*cardWidth.toInt(),
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        )
                    ),
                    CircleAvatar(
                      backgroundColor:
                      AppColors.firstColor.withOpacity(0.5),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                    )
                  ],
                  alignment: Alignment.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    podcast.podcastName!,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 14),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    podcast.description!,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {

                    callback!();

                    CommonNetworkApi()
                        .postViewed(podcast.podcastId!);
                  },
                ),
              )),
        ],
      ),
    );
  }
}
