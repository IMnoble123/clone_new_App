import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/chat_controller.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/rj_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/chat/chat_screen.dart';
import 'package:podcast_app/screens/login/login_screen.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/screens/sub_screens/about_rj_screen.dart';
import 'package:podcast_app/screens/sub_screens/profile_share_screen.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/btns/subscribe_btn.dart';
import 'package:podcast_app/widgets/btns/wrap_text_btn.dart';
import 'package:podcast_app/widgets/menus_title.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';
import 'package:podcast_app/widgets/rj_filter_categories.dart';
import 'package:podcast_app/widgets/song_info_tile.dart';

class PodcastDetailsScreen extends GetView<MainController> {
  final RjItem rjItem;

  const PodcastDetailsScreen(this.rjItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rjController = Get.put(RjController());
    rjController.updateRjItem(rjItem);
    controller.rjChipSelectedIndex.value = 0;
    controller.fetchRjsPodcasts(rjItem.rjUserId!);
    controller.fetchUnreadChatCount(rjItem.rjUserId!);

    return Container(
      padding: const EdgeInsets.all(8.0),
      /*decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'),
              fit: BoxFit.cover,
              opacity: 0.75)),*/
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 54, 0, 0), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.5])),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              /*Text(
                rjItem.rjName!,
                // 'Miss Maliksha RJ',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )*/
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  // height: rjItem.rjName!.length > 15 ? 175 : 125,
                  height: MediaQuery.of(context).size.width>600?130:150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Utility.showImageDialog(
                                    context,
                                    rjItem.profileImage!.isNotEmpty
                                        ? rjItem.profileImage!
                                        : AppConstants.dummyPic);
                              },
                              child: Image.network(
                                rjItem.profileImage!.isNotEmpty
                                    ? rjItem.profileImage!
                                    : AppConstants.dummyPic,
                                width: 120,
                                height: 120,
                                cacheWidth: 240,
                                cacheHeight: 240,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*MenusTitle(
                              text:
                                  '${rjItem.podcastCount!.isNotEmpty ? rjItem.podcastCount! : "0"} Podcasts',
                              size: 18,
                            ),*/
                            Text(
                              rjItem.rjName!,
                              // 'Miss Maliksha RJ',
                              //overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            WrapTextButton(
                              title: 'About ${rjItem.rjName}',
                              singleLine: true,
                              callback: () {
                                if (CommonNetworkApi().mobileUserId == "-1") {
                                  AppDialogs.simpleSelectionDialog(
                                          context,
                                          "Register Now",
                                          "Register Users can only view the RJ's Profiles.",
                                          "Register")
                                      .then((value) async {
                                    if (value == AppConstants.OK) {
                                      Get.find<MainController>()
                                          .tomtomPlayer
                                          .dispose();
                                      MainPage.isFirstBuild = true;
                                      await Get.delete<MainController>(
                                              force: true)
                                          .then((value) =>
                                              Get.offAll(const LoginScreen()));
                                    }
                                  });

                                  return;
                                }

                                showGeneralDialog(
                                    context: context,
                                    pageBuilder:
                                        (context, animation, secondAnimation) {
                                      return AboutRjScreen(
                                        rjItem: rjItem,
                                      );
                                    });
                              },
                              textColor: AppColors.redColor,
                              boldText: true,
                            ),
                            const Spacer(),
                            RatingBar.builder(
                              initialRating:
                                  double.parse(rjItem.rjRating ?? '1.0'),
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              unratedColor: Colors.amber.withOpacity(0.3),
                              ignoreGestures:
                                  CommonNetworkApi().mobileUserId == "-1",
                              itemCount: 5,
                              itemSize: 25,
                              //itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              tapOnlyMode: true,
                              onRatingUpdate: (rating) {
                                print(rating);

                                if (CommonNetworkApi().mobileUserId == "-1") {
                                  Utility.showRegistrationPromotion(context);
                                  return;
                                }

                                if (rjItem.isRated == "1") {
                                  AppDialogs.simpleSelectionDialog(
                                          context,
                                          "Confirmation?",
                                          "Would you like to update the rating?",
                                          "Yes")
                                      .then((value) {
                                    if (value == AppConstants.OK) {
                                      ApiService()
                                          .postData(
                                              ApiKeys.USER_RATING_SUFFIX,
                                              ApiKeys.getUserRatingQuery(
                                                  rating.toString(),
                                                  rjItem.rjUserId!))
                                          .then((value) =>
                                              displayResponse(context, value));
                                    } else {}
                                  });

                                  return;
                                }

                                ApiService()
                                    .postData(
                                        ApiKeys.USER_RATING_SUFFIX,
                                        ApiKeys.getUserRatingQuery(
                                            rating.toString(),
                                            rjItem.rjUserId!))
                                    .then((value) =>
                                        displayResponse(context, value));
                              },
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Material(
                                  child: InkWell(
                                      onTap: () {
                                        if (CommonNetworkApi().mobileUserId ==
                                            "-1") {
                                          Utility.showRegistrationPromotion(
                                              context);
                                          return;
                                        }

                                        controller
                                            .chatCountViewed(rjItem.rjUserId!);

                                        showChatWindow(context);
                                      },
                                      child: Obx(
                                        () => Badge(
                                          badgeContent: Text(
                                            controller.unReadChatCount.value,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          child: Image.asset(
                                            'images/chat_icon_new.png',
                                            width: 30,
                                            height: 30,
                                            /*color: Colors.white,*/
                                          ),
                                          badgeColor: controller
                                                      .unReadChatCount.value !=
                                                  "0"
                                              ? AppColors.firstColor
                                              : Colors.black,
                                          animationType:
                                              BadgeAnimationType.scale,
                                          showBadge: controller
                                                  .unReadChatCount.value !=
                                              "0",
                                        ),
                                      )),
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            )
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                */ /*Material(
                                  child: InkWell(
                                      onTap: () {},
                                      child: Image.asset(
                                        'images/video_chat.png',
                                        width: 30,
                                        height: 30,
                                      )),
                                  color: Colors.transparent,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),*/ /*
                                Material(
                                  child: InkWell(
                                      onTap: () {
                                        AppConstants.launchWhatsApp(
                                                context,
                                                rjItem.country!
                                                        .replaceAll('+', "") +
                                                    "" +
                                                    rjItem.rjPhone!,
                                                'hello')
                                            .then((value) {
                                          if (!value) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "whatsapp not installed")));
                                          }
                                        });
                                      },
                                      child: Image.asset(
                                        'images/whats_app.png',
                                        width: 30,
                                        height: 30,
                                      )),
                                  color: Colors.transparent,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            )*/
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  color: const Color.fromARGB(255, 54, 4, 1),
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 25,
                        /*child: RawMaterialButton(
                            // fillColor: rjItem.subscribed!.toString() == "1"?AppColors.firstColor:null,//1 means subscribed, 0 means not
                            fillColor: rjController.rjItem.value.subscribed!
                                        .toString() ==
                                    "1"
                                ? AppColors.firstColor
                                : null, //1 means subscribed, 0 means not
                            onPressed: () {


                              if (rjController.rjItem.value.subscribed!
                                      .toString() ==
                                  "0") {
                                ApiService()
                                    .postData(
                                        ApiKeys.SUBSCRIBE_SUFFIX,
                                        ApiKeys.getSubscribedQuery(
                                            rjItem.rjUserId!))
                                    .then((value) {
                                  ResponseData responseData =
                                      ResponseData.fromJson(value);

                                  if (responseData.status!.toUpperCase() ==
                                      AppConstants.SUCCESS) {
                                    rjController.rjItem.value.subscribed ="1";
                                    rjController.updateRjItem(rjItem);
                                  }else{
                                    AppDialogs.simpleOkDialog(
                                        context, 'Success', responseData.response ?? '');
                                  }
                                });
                              }
                            },
                            shape: const StadiumBorder(
                              side: BorderSide(color: AppColors.firstColor),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: rjItem.subscribed!.toString() == "1"
                                          ? "Subscribed "
                                          : "Subscribe",
                                    ),
                                    const WidgetSpan(
                                      child: Icon(
                                        Icons.notifications_none,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),*/

                        child: SubScribeButton(
                          rjItem: rjItem,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                        child: RawMaterialButton(
                          onPressed: () {
                            //showShareProfile(context);
                            //Get.to(const ProfileShareScreen());

                            showGeneralDialog(
                                context: context,
                                pageBuilder:
                                    (context, animation, secondAnimation) {
                                  return ProfileShareScreen(
                                    rjItem: rjItem,
                                  );
                                });
                          },
                          shape: const StadiumBorder(
                            side: BorderSide(color: AppColors.firstColor),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Profile ",
                                  ),
                                  WidgetSpan(
                                    child: Icon(
                                      Icons.share,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                RjFilterCategories(rjItem.rjUserId!, () {
                  updateFilter();
                }),
                /*Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: Obx(
                      () => Theme(
                        data: ThemeData(canvasColor: Colors.transparent),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            ChoiceChip(
                              label: const Text(
                                'All',
                                style: TextStyle(color: Colors.white),
                              ),
                              selected:
                                  controller.rjChipSelectedIndex.value == 0,
                              selectedColor: Colors.white.withOpacity(0.2),
                              backgroundColor: Colors.white.withOpacity(0.2),
                              shape: controller.rjChipSelectedIndex.value == 0
                                  ? const StadiumBorder(
                                      side: BorderSide(
                                          color: AppColors.firstColor))
                                  : null,
                              onSelected: (selected) {
                                controller.rjChipSelectedIndex.value = 0;
                                controller.rjPodcastFilter.value = 'All';
                                updateFilter();
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ChoiceChip(
                              label: const Text(
                                'Episodes',
                                style: TextStyle(color: Colors.white),
                              ),
                              selected:
                                  controller.rjChipSelectedIndex.value == 1,
                              selectedColor: Colors.white.withOpacity(0.2),
                              backgroundColor: Colors.white.withOpacity(0.2),
                              shape: controller.rjChipSelectedIndex.value == 1
                                  ? const StadiumBorder(
                                      side: BorderSide(
                                          color: AppColors.firstColor))
                                  : null,
                              onSelected: (selected) {
                                controller.rjChipSelectedIndex.value = 1;
                                controller.rjPodcastFilter.value = 'Episodes';
                                updateFilter();
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ChoiceChip(
                              label: const Text(
                                'Individual',
                                style: TextStyle(color: Colors.white),
                              ),
                              selected:
                                  controller.rjChipSelectedIndex.value == 2,
                              selectedColor: Colors.white.withOpacity(0.2),
                              backgroundColor: Colors.white.withOpacity(0.2),
                              shape: controller.rjChipSelectedIndex.value == 2
                                  ? const StadiumBorder(
                                      side: BorderSide(
                                          color: AppColors.firstColor))
                                  : null,
                              onSelected: (selected) {
                                controller.rjChipSelectedIndex.value = 2;
                                controller.rjPodcastFilter.value = 'Individual';
                                updateFilter();
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ChoiceChip(
                              label: const Text(
                                'News',
                                style: TextStyle(color: Colors.white),
                              ),
                              selected:
                                  controller.rjChipSelectedIndex.value == 3,
                              selectedColor: Colors.white.withOpacity(0.2),
                              backgroundColor: Colors.white.withOpacity(0.2),
                              shape: controller.rjChipSelectedIndex.value == 3
                                  ? const StadiumBorder(
                                      side: BorderSide(
                                          color: AppColors.firstColor))
                                  : null,
                              onSelected: (selected) {
                                controller.rjChipSelectedIndex.value = 3;
                                controller.rjPodcastFilter.value = 'News';
                                updateFilter();
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ChoiceChip(
                              label: const Text(
                                'Entertainment',
                                style: TextStyle(color: Colors.white),
                              ),
                              selected:
                                  controller.rjChipSelectedIndex.value == 4,
                              selectedColor: Colors.white.withOpacity(0.2),
                              backgroundColor: Colors.white.withOpacity(0.2),
                              shape: controller.rjChipSelectedIndex.value == 4
                                  ? const StadiumBorder(
                                      side: BorderSide(
                                          color: AppColors.firstColor))
                                  : null,
                              onSelected: (selected) {
                                controller.rjPodcastFilter.value =
                                    'Entertainment';

                                controller.rjChipSelectedIndex.value = 4;
                                updateFilter();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),*/
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      MenusTitle(
                        text: 'Episodes',
                        size: 22,
                      ),
                      /*Obx(
                        () => MenusTitle(
                          text:
                              'Episodes (${controller.filteredRjPodcasts.value.length})',
                          size: 22,
                        ),
                      ),*/
                      /*SizedBox(
                        height: 30,
                        child: MaterialButton(
                          onPressed: () {},
                          elevation: 0,
                          child: const Text(
                            'Sort ↑↓',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          shape: const StadiumBorder(
                              side: BorderSide(color: AppColors.firstColor)),
                        ),
                      ),*/
                    ],
                  ),
                ),
                Obx(() => controller.filteredRjPodcasts.value.isNotEmpty
                    ? updateTilesData(controller.filteredRjPodcasts.value)
                    : const NoDataWidget()),
                /*FutureBuilder(
                  builder: (context, snapShot) {
                    if (snapShot.hasData) {
                      return updateTilesData(snapShot.data);
                    } else if (snapShot.hasError) {
                      return const Text(
                        'Error',
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                      ));
                    }
                  },
                  future: ApiService().podcastListByRj(
                      ApiKeys.getRjUserQuery(rjItem.rjUserId!)),
                  // .podcastListByRj(getUserQuery(rjItem.rjUserId!)),
                  // future: ApiService().fetchTrendingPodcasts(),
                ),*/
                const SizedBox(
                  height: 150,
                ),
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget updateTilesData(List<Podcast> podcasts) {
    print(podcasts.length);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            return SongInfoTile(
              podcast: podcasts[index],
              callback: () {
                Get.find<MainController>()
                    .tomtomPlayer
                    .addAllPodcasts(podcasts, index);
              },
              playAll: () {
                Get.find<MainController>()
                    .tomtomPlayer
                    .addAllPodcasts(podcasts, 0);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: podcasts.length),
    );
  }

  /*Widget updateTilesData(dynamic data) {
    print(data);

    PodcastResponse response = PodcastResponse.fromJson(data);

    if (response.status == "Error") {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'No Results',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    List<Podcast> podcasts = response.podcasts!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            return SongInfoTile(
              podcast: podcasts[index],
              callback: () {
                Get.find<MainController>()
                    .tomtomPlayer
                    .addAllPodcasts(podcasts, index);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: podcasts.length),
    );
  }*/

  Map<String, dynamic> getUserQuery(String s) {
    return {"user_id": s};
  }

  displayResponse(context, response) {
    try {
      ResponseData responseData = ResponseData.fromJson(response);

      if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
        Utility.showSnackBar(context, 'Success');
      } else {
        Utility.showSnackBar(context, responseData.response ?? 'Failed');
      }
    } catch (e) {
      Utility.showSnackBar(context, 'Error');
    }
  }

  updateFilter() {
    if (controller.rjPodcastFilter.value.contains('All')) {
      controller.filteredRjPodcasts.value = controller.rjPodcasts.value;
    } else {
      controller.filteredRjPodcasts.value = controller.rjPodcasts.value
          .where((element) =>
              element.category!.contains(controller.rjPodcastFilter.value))
          .toList();
    }
  }

  void showChatWindow(context) {
    final controller = Get.put(ChartController());
    controller.rjId.value = rjItem.rjUserId ?? "";
    controller.fetchChatList();

    Get.to(ChatScreen(rjItem));
    /*showModalBottomSheet(
        context: AppKeys.mainScaffoldState.currentState!.context,
        isScrollControlled: true,
        clipBehavior: Clip.hardEdge,backgroundColor: const Color.fromARGB(255, 54, 0, 0),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))),
        builder: (c) {
          return SafeArea(
            child: Container(
              height: MediaQuery.of(c).size.height,
              color: Colors.transparent,
              child: ChatScreen(rjItem),
            ),
          );
        });*/
  }

/*void showShareProfile(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.white,
              height: MediaQuery.of(context).size.height,
          );
        },
        backgroundColor: Colors.black);
  }*/
}
