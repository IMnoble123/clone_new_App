import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/search_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/btns/wrap_text_btn.dart';

class SearchWidget extends GetView<SearchController> {
  final VoidCallback? callback;

  const SearchWidget(this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      color: Colors.black54,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextField(
                /*onTap: (){
                  // Get.to(const HomeScreen());
                  //Get.to(const SearchScreen());
                },*/
                //onTap: callback,
                //readOnly: true,
                controller: controller.stfController,

                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 0.0, horizontal: 15.0),
                  fillColor: Colors.white,
                  suffixIcon: Transform.translate(
                    offset: const Offset(4, 0),
                    child: Obx(
                      () => controller.searchText.value.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(3.0),
                              child: CircleAvatar(
                                backgroundColor:
                                    Color.fromARGB(255, 186, 16, 19),
                                child: ImageIcon(
                                  AssetImage('images/search_icon.png'),
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                controller.clearSearch();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: AppColors.firstColor,
                              ),
                            ),
                    ),
                  ),
                  filled: true,
                  labelStyle: const TextStyle(color: Colors.black87),
                  hintStyle: const TextStyle(color: Colors.black87),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  hintText: 'Search by Topic or Host',
                ),
                style: const TextStyle(color: Colors.black),
                onEditingComplete: () {
                  print('done click');
                  FocusScope.of(context).unfocus();
                  /*SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.immersiveSticky);*/
                },
              ),
            ),
          ),
          Obx(
            () => controller.openSearchScreen.value
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: WrapTextButton(
                      title: 'Cancel',
                      callback: () {
                        controller.closeSearchPanel();
                        Utility.hideKeyword(context);
                      },
                      textColor: Colors.white,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        // onTapDown: (details) {
                        onTap: () {
                          print('bell clicked.............');
                          // print(controller.notificationItems.length);

                          if (controller.notificationItems.value.isEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title:const  Text('No Notifications'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child:const  Text('go back'))
                                      ],
                                    ));
                          }

                          showOverlay(context);

                          /* showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                MediaQuery.of(context).size.width,
                                kToolbarHeight + 25,
                                0,
                                0),
                            items: controller.notificationItems
                                .map((element) => PopupMenuItem(
                                    onTap: () {
                                      playSelectedPodcast(element.podcastId!);
                                    },
                                    child: SizedBox(
                                      width: 600,
                                      height: 50,
                                      child: Text(
                                        element.message!,
                                        style: const TextStyle(
                                            color: AppColors.firstColor),
                                      ),
                                    )))
                                .toList(),
                            elevation: 8.0,
                          );*/

                          //controller.notificationsViewed();
                        },
                        child: Badge(
                            /*badgeContent: Text(
                              controller.notificationCount.value.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),*/
                            /*badgeContent: const Icon(
                              Icons.circle,
                              color: AppColors.firstColor,
                              size: 3,
                            ),*/
                            badgeContent: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.firstColor),
                            ),
                            badgeColor: const Color.fromARGB(255, 33, 0, 0),
                            animationType: BadgeAnimationType.scale,
                            showBadge: controller.notificationCount.value != 0,
                            child: const ImageIcon(
                              AssetImage('images/notification_icon.png'),
                              color: Colors.white,
                            )),
                      ),
                    )),
          ),
        ],
      ),
    );
  }

  void playSelectedPodcast(String podcastId) async {
    final responseData = await ApiService().postData(
        ApiKeys.PODCAST_BY_ID_SUFFIX,
        ApiKeys.getPodcastsByPodcastIdQuery(podcastId));

    PodcastResponse response =
        PodcastResponse.fromJson(responseData as dynamic);

    if (response.status == "Error" || response.podcasts == null) {
      return;
    }

    List<Podcast> podcasts = response.podcasts!;

    if (podcasts.isNotEmpty) {
      Get.find<MainController>().tomtomPlayer.addAllPodcasts(podcasts, 0);
      Get.find<MainController>().togglePanel();
    }
  }

  ///******************************************************* **************************///

  static OverlayEntry? overlayEntry;

  void showOverlay(BuildContext context) {
    OverlayState? overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return GestureDetector(
        onTap: () {
          overlayEntry?.remove();
          controller.notificationsViewed();
        },
        child: Container(
            margin: const EdgeInsets.only(top: kToolbarHeight),
            color: Colors.black.withOpacity(0.6),
            child: ListView.builder(
              /*separatorBuilder: (context, index) {
                return Container(
                  color: const Color.fromARGB(255, 82, 7, 9),
                  height: 150,
                 */ /* child: Divider(
                    color: Colors.white.withOpacity(0.4),
                  ),*/ /*
                );
              },*/
              itemBuilder: (context, index) {
                return Material(
                  /*child: ListTile(
                    tileColor: const Color.fromARGB(255, 82, 7, 9),
                    leading: const Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 10,
                    ),
                    title: Text(
                      controller.notificationItems.value[index].message!+ " Sample text for notifications fotr testing djkahjnv jkfnvjkadv kxbvkb",
                      style: const TextStyle(color: Colors.white,fontSize: 16),
                    ),
                  ),*/
                  child: InkWell(
                    onTap: () {
                      print('tapped');

                      overlayEntry?.remove();
                      controller.notificationsViewed();

                      playSelectedPodcast(
                          controller.notificationItems[index].podcastId!);
                    },
                    child: Container(
                      color: const Color.fromARGB(255, 82, 7, 9),
                      padding: EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                          bottom:
                              index == controller.notificationItems.length - 1
                                  ? 25
                                  : 15,
                          top: index == 0 ? 20 : 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          const Icon(
                            Icons.circle,
                            color: Colors.red,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Text(
                              controller.notificationItems[index].message!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: controller.notificationItems.length,
            )),
      );
    });

    overlayState?.insert(overlayEntry!);
  }
}

class PopUpMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isActive;

  const PopUpMenuTile(
      {Key? key,
      required this.icon,
      required this.title,
      required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(icon,
            color: isActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).primaryColor),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.headline4!.copyWith(
              color: isActive
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).primaryColor),
        ),
      ],
    );
  }
}
