import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/collections_data_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';

class CollectionUiItem extends StatelessWidget {
  final CollectionItem item;
  final PlayListController playListController;
  final VoidCallback deleteCallback;

  const CollectionUiItem(
      {Key? key,
      required this.item,
      required this.playListController,
      required this.deleteCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: 100,
          //height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'images/folder.png',
                        width: 100,
                        //height: 100,
                        fit: BoxFit.fitWidth,
                      )),
                ],
                alignment: Alignment.center,
              ),
              const Divider(height: 8.0,),
              Align(
                alignment: Alignment.center,
                child: Text(
                  item.folderName!,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
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
              playListController.selectedCollectionId.value = item.folderId!;
              playListController.selectedCollectionName.value =
                  item.folderName!;

              playListController.fetchPodcastByCollectionId();
            },
            onLongPress: () {},
          ),
        )),
        /*Positioned(
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.5),
            radius: 10,
            child: IconButton(

                onPressed: () {
                  deleteCallback();
                },
                icon: const Icon(
                  Icons.delete,
                  color: AppColors.firstColor,
                  size: 15,
                )),
          ),
          right: 0,
          top: 25,
        ),*/
        Positioned(
          child: InkWell(
            onTap: (){
              deleteCallback();
            },
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.5),
              radius: 10, child: const Icon(Icons.delete_rounded,color: AppColors.firstColor,size: 15,),
            ),
          ),
          right: 10,
          top: 0,
          bottom: 62,
        ),
      ],
    );
  }
}
