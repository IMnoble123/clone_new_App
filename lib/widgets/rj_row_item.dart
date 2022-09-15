import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/rj_response.dart';

class RjRowItem extends StatelessWidget {
  final RjItem rjItem;
  final VoidCallback? callback;

  const RjRowItem(
      {Key? key, required this.rjItem, this.callback})
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
              ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: rjItem.profileImage!
                            .isNotEmpty /*&&
                        !rjItem.profileImage!.contains(".jfif")*/
                        ? rjItem.profileImage!
                        : AppConstants.dummyRjPic,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                    memCacheWidth: 256,
                    memCacheHeight: 256,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )),
              /*ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    rjItem.profileImage!.isNotEmpty
                        ? rjItem.profileImage!
                        : AppConstants.dummyPic,
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  )),*/
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rjItem.rjName ?? '',
                      // overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    /*Text(
                      rjItem.podcasterType ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.disableColor,
                      ),
                    ),*/
                  ],
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.5),
                ),
              )
            ],
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: callback != null
                  ? callback!
                  : () {
                      //Get.find<MainController>().togglePanel();

                      // FocusScope.of(context).unfocus();

                      Navigator.pushNamed(
                          context, AppRoutes.podcastDetailsScreen,
                          arguments: rjItem);
                    },
            ),
          ))
        ],
      ),
    );
  }
}
