import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/models/response/rj_response.dart';

import '../extras/constants.dart';

class RjPaginationItem extends StatelessWidget {
  final double cardWidth;
  final RjItem rjItem;
  final VoidCallback? callback;
  const RjPaginationItem({Key? key, required this.cardWidth, required this.rjItem, this.callback}) : super(key: key);

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
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: rjItem
                              .profileImage!
                              .isNotEmpty /*&&
                                    !rjItems[index].profileImage!.contains(".jfif")*/
                              ? rjItem.profileImage!
                              : AppConstants.dummyRjPic,
                          width: cardWidth,
                          height: cardWidth,
                          fit: BoxFit.cover,
                          memCacheWidth: 2*cardWidth.toInt(),
                          memCacheHeight: 2*cardWidth.toInt(),
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        )),

                  ],
                  alignment: Alignment.center,
                ),
                const SizedBox(
                  height: 5,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    rjItem.rjName!,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 14),
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
                    //callback!(rjItems[index]);
                   callback!();
                  },
                ),
              )),
        ],
      ),
    );
  }
}

