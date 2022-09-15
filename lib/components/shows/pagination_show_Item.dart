import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/shows_response_data.dart';

class PaginationShowItem extends StatelessWidget {
  final double cardWidth;
  final ShowItem showItem;
  final VoidCallback? callback;
  const PaginationShowItem({Key? key, required this.cardWidth, required this.showItem, this.callback}) : super(key: key);

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
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: showItem.showsImage!.isNotEmpty &&
                          !showItem.showsImage!.contains(".jfif")
                          ? showItem.showsImage!
                          : AppConstants.dummyPic,
                      width: cardWidth,
                      height: cardWidth,
                      memCacheWidth: cardWidth.toInt()*2,
                      memCacheHeight: cardWidth.toInt()*2,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                    )),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    showItem.showsName!,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 14),
                  ),
                ),
                /*Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${shows[index].totalPodcast!} episodes ',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12),
                        ),
                      ),*/
              ],
            ),
          ),
          Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {

                    callback!();


                  },
                ),
              )),
        ],
      ),
    );
  }
}
