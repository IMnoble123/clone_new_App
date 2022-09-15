import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/models/response/category_response.dart';

import '../extras/constants.dart';

class PaginationCatItem extends StatelessWidget {
  final double cardWidth;
  final Category category;
  final VoidCallback? callback;
  const PaginationCatItem({Key? key, required this.cardWidth, required this.category, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Stack(
        children: [
          SizedBox(
            width: cardWidth,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  child: Container(
                    width: cardWidth,
                    height: cardWidth,
                    decoration: const BoxDecoration(
                        color: Colors.transparent,
                        // color: AppColors.firstColor.withOpacity(0.25),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: CachedNetworkImage(
                      imageUrl: category.image!.isNotEmpty
                          ? category.image!
                          : AppConstants.dummyPic,
                      /*memCacheWidth: cardWidth.toInt(),
                      memCacheHeight: cardWidth.toInt(),*/
                      fit: BoxFit.cover,

                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Flexible(
                  child: Text(
                    category.name ?? "",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                )
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
              ))
        ],
      ),
    );
  }
}
