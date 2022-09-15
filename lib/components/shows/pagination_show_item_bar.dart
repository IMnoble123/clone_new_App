import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/shows_response_data.dart';
import 'package:podcast_app/screens/main/main_page.dart';

class PaginationShowItemBar extends StatelessWidget {
  final ShowItem showItem;
  final VoidCallback? callback;

  const PaginationShowItemBar(
      {Key? key,
      required this.showItem,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: const BorderRadius.all(Radius.circular(8.0))),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 10,
              ),
              Stack(alignment: Alignment.center, children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: showItem.showsImage!.isNotEmpty &&
                              !showItem.showsImage!.contains(".jfif")
                          ? showItem.showsImage!
                          : AppConstants.dummyPic,
                      width: 75,
                      height: 75,
                      memCacheWidth: 256,
                      memCacheHeight: 256,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )),
              ]),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showItem.showsName ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    /*Text(
                          '${showItem.totalPodcast ?? '0'} episodes',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.disableColor,
                          ),
                        )*/
                  ],
                ),
              )),
              /*IconButton(
                      splashColor: AppColors.firstColor.withOpacity(0.4),
                      onPressed: () {

                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ))*/
            ],
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                //Get.find<MainController>().togglePanel();

                FocusScope.of(MainPage.activeContext!).unfocus();

                callback!();
              },
            ),
          ))
        ],
      ),
    );
  }
}
