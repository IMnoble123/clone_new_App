import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/dynamic_links_service.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/share_prefs.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/chat_text_field.dart';
import 'package:podcast_app/widgets/comment/main_comment_screen.dart';
import 'package:podcast_app/widgets/stroke_circular_btn.dart';
import 'package:share_plus/share_plus.dart';
import 'sub_screens/podcast_more_options_screen.dart';

class SlideUpScreen extends GetView<MainController> {
  const SlideUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(controller.hashCode);
    DateTime? currentBackPressTime;

    bool isKeyboardShowing = MediaQuery.of(context).viewInsets.vertical > 0;

    if (controller.enableCommentEditField.value && !isKeyboardShowing) {
      controller.enableCommentEditField.value = false;
    }

    return Container(
      /*decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover)),*/
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 54, 0, 0), Colors.black],
              /*colors: [
                Colors.red.withOpacity(0.5),
                Colors.black.withOpacity(0.5)
              ],*/
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.5])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                print("test");
                controller.togglePanel();
              },
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  print("test");
                  //Get.to(const PodcastMoreOptionsScreen());

                  showGeneralDialog(
                      context: context,
                      pageBuilder: (context, animation, secondAnimation) {
                        return const PodcastMoreOptionsScreen();
                      });
                },
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                ))
          ],
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          //reverse: MediaQuery.of(context).viewInsets.bottom!=0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Obx(() =>
                          /*Image.network(
                                controller.coverPic.value,
                                //'https://99designs-blog.imgix.net/blog/wp-content/uploads/2018/01/attachment_91327424-e1515420211463.png?auto=format&q=60&fit=max&w=930',
                                // 'https://qqcdnpictest.mxplay.com/pic/8bd21b4e7f4fae507246e2f77e631fee/en/2x3/320x480/test_pic1635764009166.webp',
                                fit: BoxFit.fitWidth,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                //height: MediaQuery.of(context).size.width,
                                //width: MediaQuery.of(context).size.width,
                              )*/
                          CachedNetworkImage(
                            imageUrl: controller.coverPic.value.isNotEmpty
                                ? controller.coverPic.value
                                : AppConstants.dummyPic,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Obx(
                        () => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                controller.podcastName.value,
                                /*overflow: TextOverflow.ellipsis,*/
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  gotoRjPage(
                                      controller.currentPodcast!.userId!);
                                },
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'By ${controller.podcastBy.value}',
                                      /*overflow: TextOverflow.ellipsis,*/
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          decoration: TextDecoration.underline,
                                          fontSize: 14),
                                    )),
                              ),
                            ),
                            /*Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  // controller.podcastDate.value.split(" ")[0],
                                  Utility.getRequiredDateFormat(
                                      controller.podcastDate.value),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.5),
                                      fontSize: 14),
                                )),*/
                          ],
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (CommonNetworkApi().mobileUserId == "-1") {
                                Utility.showRegistrationPromotion(context);
                                return;
                              }

                              if (controller.isLikeClicked.value) {
                                ApiService().postData(
                                    ApiKeys.LIKE_DIS_LIKE_HEART_SUFFIX,
                                    ApiKeys.getLdhQuery(
                                        controller.podcastId.value, 'like'));
                                controller.like.value -= 1;
                              } else {
                                ApiService().postData(
                                    ApiKeys.LIKE_DIS_LIKE_HEART_SUFFIX,
                                    ApiKeys.getLdhQuery(
                                        controller.podcastId.value, 'like'));

                                controller.like.value += 1;
                              }
                              controller.isLikeClicked.value =
                                  !controller.isLikeClicked.value;
                            }
                            /*onPressed: () {
                              if (controller.isLikeClicked.value) {
                                ApiService().deleteData(
                                    ApiKeys.FAV_SUFFIX,
                                    ApiKeys.getFavouriteQuery(
                                        controller.podcastId.value));
                                controller.like.value-=1;
                              } else {
                                ApiService().postData(
                                    ApiKeys.FAV_SUFFIX,
                                    ApiKeys.getFavouriteQuery(
                                        controller.podcastId.value));

                                controller.like.value+=1;
                              }
                              controller.isLikeClicked.value =
                                  !controller.isLikeClicked.value;
                            }*/
                            ,
                            icon: Obx(
                              () => controller.isLikeClicked.value
                                  ? const Icon(
                                      Icons.favorite,
                                      size: 30.0,
                                      color: AppColors.firstColor,
                                    )
                                  : const Icon(
                                      Icons.favorite_border,
                                      size: 30.0,
                                      color: AppColors.firstColor,
                                    ),
                            )),
                        Obx(
                          () => Text(
                            '${controller.like.value} Likes',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    //const Spacer(),
                    /* InkWell(
                        onTap: () {},
                        child: Image.asset(
                          'images/video_chat.png',
                          width: 30,
                          height: 30,
                        )),
                    const SizedBox(
                      width: 30,
                    ),*/
                    /*Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: () {
                              AppConstants.launchWhatsApp(
                                      context, '918179860808', 'hello')
                                  .then((value) {
                                if (!value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text("whatsapp not installed")));
                                }
                              });

                              //launchWhatsApp(context,'918179860808', '');
                              // String url = "https://api.whatsapp.com/send?phone=918179860806&text=Hello";
                              */ /*String url =
                                  "whatsapp://send?phone=918179860808&text=hello";*/ /*
                              //await launch(url);
                              // await launch(AppConstants.whatsAppUrl('918179860807', 'Hello'));
                              // await launch(Uri.encodeFull(AppConstants.url));
                            },
                            child: Image.asset(
                              'images/whats_app.png',
                              width: 30,
                              height: 30,
                            )),
                      ),
                    ),*/
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                  child: SliderTheme(
                    data: const SliderThemeData(
                      thumbShape: StrokeThumb(stroke: 2.0, thumbRadius: 10.0),
                      overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 15.0),
                    ),
                    child: Obx(
                      () => Slider(
                        min: 0,
                        max: controller.maxDuration.value != 0.0
                            ? controller.maxDuration.value
                            : 1.0,
                        value: controller.maxDuration.value >
                                controller.seekPosition.value
                            ? controller.seekPosition.value
                            : controller.maxDuration.value,
                        onChanged: (v) {
                          controller.updateSeekPosition(v);
                          /*setState(() {
                            seekProgress = v;
                          });*/
                        },
                        onChangeStart: (v) {
                          controller.isSeekbarTouched.value = true;
                        },
                        onChangeEnd: (v) {
                          controller.isSeekbarTouched.value = false;

                          controller.updateSeekPositionEnd(v);
                        },
                        activeColor: AppColors.firstColor,
                        inactiveColor: AppColors.inActiveColor,
                        thumbColor: AppColors.firstColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      Obx(
                        () => Text(
                          formatHHMMSS(
                              controller.currentPosition.value.toInt()),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      Obx(
                        () => Text(
                          formatHHMMSS(controller.maxDuration.value.toInt()),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      /*InkWell(
                          onTap: () {
                            bool b = !controller.isSongShuffle.value;
                            controller.updateSongShuffle(b);

                            AppSharedPreference()
                                .saveBoolData(AppConstants.SONG_SHUFFLE, b);
                          },
                          child: Obx(
                            () => Image.asset(
                              'images/shuffle.png',
                              width: 25,
                              height: 25,
                              color: controller.isSongShuffle.value
                                  ? AppColors.firstColor
                                  : AppColors.iconColor2,
                            ),
                          )),*/
                      InkWell(
                          onTap: () {
                            bool b = !controller.isSongLooped.value;
                            controller.updateSongLoop(b);

                            AppSharedPreference()
                                .saveBoolData(AppConstants.SONG_LOOP, b);
                          },
                          child: Obx(
                            () => Image.asset(
                              'images/loop.png',
                              width: 25,
                              height: 25,
                              color: controller.isSongLooped.value
                                  ? AppColors.firstColor
                                  : AppColors.iconColor2,
                            ),
                          )),
                      const Spacer(),
                      Obx(
                        () => StrokeCircularButton(
                          iconData: Icons.skip_previous,
                          disable: controller.isFirstPodcast.value,
                          callback: () {
                            //controller.updateSeekPosition(0.0);

                            DateTime now = DateTime.now();

                            if (currentBackPressTime == null ||
                                now.difference(currentBackPressTime!) >
                                    const Duration(seconds: 3)) {
                              currentBackPressTime = now;

                              controller.updateSeekPosition(0.0);
                            } else {
                              controller.previousPodcast();
                            }
                          },
                          strokeWidth: 2,
                          iconSize: 30,
                        ),
                      ),
                      Obx(
                        () => controller.isLoadingPodcast.value
                            ? const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Center(
                                  child: SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: CircularProgressIndicator()),
                                ),
                              )
                            : StrokeCircularButton(
                                iconData: controller.isPlaying.value
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                callback: () {
                                  /*controller.updatePlayingState(
                                      !controller.isPlaying.value);*/

                                  if (controller.isPlaying.value) {
                                    controller.pausePodcast();
                                  } else {
                                    controller.playPodcast();
                                  }
                                },
                                strokeWidth: 2,
                                iconSize: 30,
                                bgColor: AppColors.firstColor,
                              ),
                      ),
                      Obx(
                        () => StrokeCircularButton(
                          iconData: Icons.skip_next,
                          disable: controller.isLastPodcast.value,
                          callback: () {
                            controller.nextPodcast();
                          },
                          strokeWidth: 2,
                          iconSize: 30,
                        ),
                      ),
                      const Spacer(),
                      /*InkWell(
                          onTap: () {
                            bool b = !controller.isSongLooped.value;
                            controller.updateSongLoop(b);

                            AppSharedPreference()
                                .saveBoolData(AppConstants.SONG_LOOP, b);
                          },
                          child: Obx(
                            () => Image.asset(
                              'images/loop.png',
                              width: 25,
                              height: 25,
                              color: controller.isSongLooped.value
                                  ? AppColors.firstColor
                                  : AppColors.iconColor2,
                            ),
                          )),*/
                      /*IconButton(
                          onPressed: () {

                            if (CommonNetworkApi().mobileUserId != "-1") {

                              DynamicLinksService.createDynamicLink(
                                  controller.currentPodcast!)
                                  .then((value) {
                                print(value);
                                Share.share(value);

                              });

                            } else {
                              Utility.showRegistrationPromotion(context);
                            }

                          },
                          icon: const Icon(
                            Icons.share,
                            color: AppColors.firstColor,
                          )),*/

                      InkWell(
                        onTap: () {
                          if (CommonNetworkApi().mobileUserId != "-1") {
                            DynamicLinksService.createDynamicLink(
                                    controller.currentPodcast!)
                                .then((value) async {
                              Share.share(value);
                            });
                          } else {
                            Utility.showRegistrationPromotion(context);
                          }
                        },
                        child: const Icon(
                          Icons.share,
                          color: AppColors.firstColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(
                    () => Text(
                      'Comments ( ${controller.comments.length} )',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                IgnorePointer(
                  ignoring: CommonNetworkApi().mobileUserId == "-1",
                  child: Opacity(
                      opacity:
                          CommonNetworkApi().mobileUserId != "-1" ? 1.0 : 0.4,
                      child: ChatTextField(
                        mainContext: context,
                      )),
                ),

                /* Container(
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                          width: 0.21,
                          color: Colors.grey,
                          style: BorderStyle.solid)),
                  child: InkWell(
                    onTap: () {
                      if (CommonNetworkApi().mobileUserId != "-1") {
                        controller.enableCommentEditField.value = true;
                        return;
                      }

                      AppDialogs.simpleSelectionDialog(
                              context,
                              "Register Now",
                              "Register Users have ability to provide comments.",
                              "Register")
                          .then((value) async {
                        if (value == AppConstants.OK) {
                          Get.find<MainController>().tomtomPlayer.dispose();
                          MainPage.isFirstBuild = true;
                          await Get.delete<MainController>(force: true).then(
                              (value) => Get.offAll(const LoginScreen()));
                        }
                      });
                    },
                    child: TextField(
                      minLines: 10,
                      maxLines: 20,
                      enabled: false,
                      controller: controller.commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: 'comment here',
                          contentPadding: const EdgeInsets.all(15),
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.send,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (value) {},
                      onSubmitted: (val) {
                        controller.addComment(comment: val);
                      },
                    ),
                  ),
                ),*/
                /*Container(
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                          width: 0.21,
                          color: Colors.grey,
                          style: BorderStyle.solid)),
                  child: CommonNetworkApi().mobileUserId != "-1"?TextField(
                    minLines: 10,
                    maxLines: 20,
                    controller: controller.commentController,
                    style: const TextStyle(color: Colors.white),
                    decoration:  InputDecoration(
                        hintText: 'comment here',
                        contentPadding: const EdgeInsets.all(15),
                        labelStyle: const TextStyle(color: Colors.white),
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                        border: InputBorder.none),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.send,
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (value) {},
                    onSubmitted: (val) {
                      controller.addComment(comment:val);
                    },
                  ):InkWell(
                    onTap: (){

                      if(CommonNetworkApi().mobileUserId != "-1"){
                        controller.enableCommentEditField.value = true;
                        return ;
                      }

                      AppDialogs.simpleSelectionDialog(
                          context,
                          "Register Now",
                          "Register Users have ability to provide comments.",
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

                    },
                    child: TextField(
                      minLines: 10,
                      maxLines: 20,
                      enabled: false,
                      controller: controller.commentController,
                      style: const TextStyle(color: Colors.white),
                      decoration:  InputDecoration(
                          hintText: 'comment here',
                          contentPadding: const EdgeInsets.all(15),
                          labelStyle: const TextStyle(color: Colors.white),
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                          border: InputBorder.none),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.send,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      onChanged: (value) {},
                      onSubmitted: (val) {
                        controller.addComment(comment:val);
                      },
                    ),
                  ),
                ),*/
                /*GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        'Upload images / gifs / videos comments',
                        style: TextStyle(
                            fontSize: 10, color: AppColors.disableColor),
                      ),
                      Icon(
                        Icons.upload_rounded,
                        color: AppColors.disableColor,
                        size: 15,
                      )
                    ],
                  ),
                  onTap: () => controller.showOptionsSheet(context),
                ),*/
                const SizedBox(
                  height: 10,
                ),
                const MainCommentsScreen(),
                Obx(
                  () => controller.commentsLoad.value
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Center(
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator()),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
        /*bottomSheet: Obx(
          () => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 100 : 30,
            ),
            child: Container(
              color: Colors.transparent,
              child: controller.enableCommentEditField.value
                  ?  ChatTextField(mainContext: context,)
                  : const SizedBox.shrink(),
              // child: MediaQuery.of(context).viewInsets.bottom!=0? const ChatTextField():const SizedBox.shrink(),
            ),
          ),
        ),*/
      ),
    );
    /*return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              print("test");
              controller?.togglePanel();
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white,
            )),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                print("test");
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ))
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.rectangle,
                image: DecorationImage(
                    image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover)),
          ),
          Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                          image: AssetImage('images/sample.png'),
                          fit: BoxFit.cover)))
            ],
          )
        ],
      ),
    );*/
  }

  String getHHmm(double seconds) {
    int minutes = (seconds / 60).truncate();
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    return minutesStr;
  }

  String formatHHMMSS(int seconds) {
    if (seconds != 0) {
      int hours = (seconds / 3600).truncate();
      seconds = (seconds % 3600).truncate();
      int minutes = (seconds / 60).truncate();

      String hoursStr = (hours).toString().padLeft(2, '0');
      String minutesStr = (minutes).toString().padLeft(2, '0');
      String secondsStr = (seconds % 60).toString().padLeft(2, '0');

      if (hours == 0) {
        return "$minutesStr:$secondsStr";
      }
      return "$hoursStr:$minutesStr:$secondsStr";
    } else {
      return "00:00";
    }
  }

  void gotoRjPage(String rjId) async {
    final responseData = await ApiService()
        .postData(ApiKeys.RJ_BYID_SUFFIX, ApiKeys.getRjByRjIdQuery(rjId));

    RjResponse response = RjResponse.fromJson(responseData);

    if (response.status == "Success") {
      RjItem rjItem = response.rjItems![0];
      controller.togglePanel();
      Navigator.pushNamed(
          MainPage.activeContext!, AppRoutes.podcastDetailsScreen,
          arguments: rjItem);
    }
  }
}

class StrokeThumb extends SliderComponentShape {
  final double thumbRadius;
  final double stroke;

  const StrokeThumb({
    required this.thumbRadius,
    required this.stroke,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;

    var paint1 = Paint()
      ..color = AppColors.firstColor
      ..strokeWidth = stroke
      ..style = PaintingStyle.fill;

    var paint2 = Paint()
      ..color = Colors.white
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, thumbRadius, paint1);
    canvas.drawCircle(center, thumbRadius, paint2);
  }
}
