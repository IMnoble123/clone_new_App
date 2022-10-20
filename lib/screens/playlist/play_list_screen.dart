import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/models/item.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/screens/playlist/all_playlist_screen.dart';
import 'package:podcast_app/screens/playlist/downloaded_screen.dart';
import 'package:podcast_app/screens/playlist/fav_list.dart';
import 'package:podcast_app/screens/playlist/play_list_chips.dart';
import 'package:podcast_app/screens/playlist/subscribed_list.dart';
import 'package:podcast_app/widgets/menus_title.dart';

class PlayListScreen extends GetView<PlayListController> {
  const PlayListScreen({Key? key}) : super(key: key);

  static final List<Item> _items = List.generate(
      15,
      (index) => Item.fromJson({
            "id": 1,
            "imgUrl":
                "https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/6a/e4/59/6ae45956-8b3d-0ff2-81f8-587c7c65b515/source/512x512bb.jpg",
            "title": "Folder",
            "subtitle": ""
          }));

  @override
  Widget build(BuildContext context) {
    print(controller.hashCode);

    MainPage.activeContext = context;

    return Container(
      color: Colors.black.withOpacity(0.3),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MenusTitle(
            text: 'Playlists',
          ),
          const PlayListChips(),
          //Obx(()=> MenusTitle(text: 'by '+PlayListChips.chipsTitles[controller.chipSelectedIndex.value])),
          Expanded(child: Obx(() => getDynamicWidget())),


          /*Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'by Folder',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [for (var item in _items) ItemWidget(item)],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'by List',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
          ListView.separated(
            itemBuilder: (context, index) {
              return SongInfoTile(
                callback: () {},
              );
            },
            itemCount: 0,
            primary: false,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return Divider(
                height: 10,
              );
            },
          ),
          SizedBox(
            height: 50,
          )*/
        ],
      ),
    );
  }

  Widget ItemWidget(Item item) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          SizedBox(
            width: 100,
            //height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      item.imgUrl!,
                      width: 100,
                      height: 100,cacheWidth: 100,cacheHeight: 100,
                    )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.title!,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.subtitle!,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.75), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
            ),
          ))
        ],
      ),
    );
  }

  getDynamicWidget() {
    switch (controller.chipSelectedIndex.value) {
      case 0:
        return const AllPlayListScreen();
      case 1:
        return const DownloadedScreen(
          title: 'Downloaded',
        );

      case 2:
        return FavoriteList(
          apiSuffix: ApiKeys.FAV_LIST_SUFFIX,
          query: ApiKeys.getFavouriteListQuery('listenlater'),
          title: 'Listen Later',
        );

      case 3:
        return const SubscribedPodcasts();

      case 4:
        return FavoriteList(
          apiSuffix: ApiKeys.FAV_LIST_SUFFIX,
          query: ApiKeys.getFavouriteListQuery('favourite'),
          title: 'Favourite',
        );
      case 5:
        return FavoriteList(
          apiSuffix: ApiKeys.YOUR_LISTENED_PODCAST_SUFFIX,
          query: ApiKeys.getMobileUserQuery(),
          title: 'History',
        );
    }
  }
}
