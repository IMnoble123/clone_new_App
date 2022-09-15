import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/models/response/category_response.dart';

class PaginationCatGridItem extends StatelessWidget {
  final double cardWidth;
  final Category category;
  final VoidCallback? callback;

  const PaginationCatGridItem({Key? key, required this.category, this.callback, required this.cardWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                      //color: AppColors.firstColor.withOpacity(0.4),
                        width: double.infinity,
                        //padding: const EdgeInsets.all(16.0),
                        child: /*SvgPicture.network(
                        category.image!.isNotEmpty
                            ? category.image!
                            : "http://i.pinimg.com/474x/87/2f/e3/872fe3815376b2cd32106527eac73b73.jpg",fit: BoxFit.cover,
                      ),*/
                        CachedNetworkImage(
                          imageUrl: category.image!.isNotEmpty
                              ? category.image!
                              : AppConstants.dummyPic,
                          fit: BoxFit.cover,
                          width: cardWidth,
                          height: cardWidth,
                          memCacheWidth: cardWidth.toInt() * 2,
                          memCacheHeight: cardWidth.toInt() * 2,
                        ))
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category.name ?? '',
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              const SizedBox(
                height: 10,
              ),
            ],
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
