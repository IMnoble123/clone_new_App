import 'dart:io';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/search_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/dynamic_links_service.dart';
import 'package:podcast_app/extras/keys.dart';
import 'package:podcast_app/extras/share_prefs.dart';
import 'package:podcast_app/main.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/main/dynamic_widget.dart';
import 'package:podcast_app/screens/playlist/playlist_search_screen.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/bg/gradient_bg.dart';
import 'package:podcast_app/widgets/bottom_navigation.dart';
import 'package:podcast_app/widgets/search_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../collapsed_screen.dart';
import '../search_screen.dart';
import '../slide_up_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  static bool isFirstBuild = true;

  static BuildContext? activeContext;

  static GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    print('rebilded!!!');

    try {
      FlutterNativeSplash.remove();
    } catch (e) {}

    /*final searchController = Get.put(SearchController()) ;*/
    final mainController = Get.put(MainController());

    final searchController = Get.find<SearchController>();
    //final mainController = Get.find<MainController>();

    if(TomTomApp.podcastId.isNotEmpty){

      Future.delayed(const Duration(seconds: 3),(){
        playSelectedPodcast(TomTomApp.podcastId);
      });

    }

    if (isFirstBuild) {
      Future.delayed(const Duration(seconds: 1), () {
        mainController.panelController.hide();

        AppSharedPreference()
            .getBool(AppConstants.SONG_LOOP, defaultValue: true)
            .then((value) => mainController.updateSongLoop(value));

        AppSharedPreference()
            .getBool(AppConstants.SONG_SHUFFLE)
            .then((value) => mainController.updateSongShuffle(value));

        searchController.fetchNotifications();

        DynamicLinksService.initDynamicLinks();
      });

      registerFcmToken(context);

      isFirstBuild = false;
    }

    return WillPopScope(
      onWillPop: () => Future<bool>.value(false),
      child: SafeArea(
        child: Scaffold(
          key: AppKeys.mainScaffoldState,
          resizeToAvoidBottomInset: false,
          body: GestureDetector(
            onPanDown: (e) {
              fabKey.currentState!.close();
            },
            child: Stack(
              children: [
                SlidingUpPanel(
                  key: AppKeys.panelKey,
                  backdropTapClosesPanel: true,
                  controller: mainController.panelController,
                  body: Stack(
                    children: [
                      const LinearGradientBg(),
                      /*Container(
                        height: double.infinity,
                        decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.rectangle,
                            image: DecorationImage(
                                image: AssetImage('images/ob_bg.png'),
                                fit: BoxFit.cover)),
                      ),*/
                      /* if (mainController.selectedIndex.value == 0 ||
                          mainController.selectedIndex.value == 1)*/
                      Obx(
                        () => mainController.selectedIndex.value == 0 ||
                                mainController.selectedIndex.value == 1
                            ? SizedBox(
                                height: kToolbarHeight,
                                //color: Colors.amber,
                                child: SearchWidget(() {}))
                            : const SizedBox.shrink(),
                      ),
                      Obx(
                        () => Positioned.fill(
                          top: mainController.selectedIndex.value == 0 ||
                                  mainController.selectedIndex.value == 1
                              ? kToolbarHeight
                              : 0,
                          child: const SizedBox(
                            height: double.infinity,
                            child: DynamicWidget(),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        top: kToolbarHeight,
                        bottom: 0, //kBottomNavigationBarHeight,
                        child: SizedBox(
                          height: double.infinity,
                          child: Obx(
                            () => searchController.isFromPlayList.value &&
                                    searchController.openSearchScreen.value
                                ? SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height,
                                    child: const PlayListSearchScreen(),
                                  )
                                : !searchController.isFromPlayList.value &&
                                        searchController.openSearchScreen.value
                                    ? const SizedBox(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: SearchScreen(),
                                      )
                                    : const SizedBox.shrink(),
                          ),
                        ),
                      ),
                      /*Positioned.fill(
                        top: kToolbarHeight,
                        bottom: 0, //kBottomNavigationBarHeight,
                        child: SizedBox(
                          height: double.infinity,
                          child: Obx(
                            () => searchController.openSearchScreen.value
                                ? const SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: SearchScreen(),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),
                      ),*/

                      Obx(() => mainController.showProgress.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : const SizedBox.shrink())
                    ],
                  ),
                  panel: const SlideUpScreen(),
                  minHeight: kToolbarHeight,
                  maxHeight: MediaQuery.of(context).size.height,
                  collapsed: const CollapsedScreen(),
                ),

                /* Positioned(
                  child: circularMenu,
                  right: 10,
                  top: kToolbarHeight,
                ),*/

                /*Obx(
                  () => Positioned(
                    child: circularMenu,
                    */ /*child: Column(
                      children: [
                        Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.hardEdge,
                            child: IconButton(
                              onPressed: () {
                                if (mainController.showSocialBtns.value == 0.0) {
                                  mainController.showSocialBtns.value = 1.0;
                                } else {
                                  mainController.showSocialBtns.value = 0.0;
                                }
                              },
                              icon: Icon(
                                mainController.showSocialBtns.value == 0.0
                                    ? Icons.language
                                    : Icons.clear,
                                color: AppColors.firstColor,
                              ),
                              splashColor: Colors.red.withOpacity(0.5),
                              iconSize: 30,
                              splashRadius: 50,
                            )),
                        AnimatedSocialIcon(
                            iconPath: 'images/fb.png',
                            callback: () {
                              mainController.showSocialBtns.value = 0.0;
                              Utility.openUrls(context, AppConstants.FB_PAGE);
                            }),
                        AnimatedSocialIcon(
                            iconPath: 'images/instagram.png',
                            callback: () {
                              mainController.showSocialBtns.value = 0.0;
                              Utility.openUrls(context, AppConstants.IG_PAGE);
                            }),
                        AnimatedSocialIcon(
                            iconPath: 'images/twitter.png',
                            callback: () {
                              mainController.showSocialBtns.value = 0.0;
                              Utility.openUrls(context, AppConstants.TW_PAGE);
                            }),
                        AnimatedSocialIcon(
                            iconPath: 'images/web_icon.png',
                            callback: () {
                              mainController.showSocialBtns.value = 0.0;
                              Utility.openUrls(context, AppConstants.WEB_PAGE);
                            }),
                        */ /* */ /*AnimatedSocialIcon(
                              iconPath: 'images/telegram.png',
                              callback: () {
                                mainController.showSocialBtns.value = 0.0;
                                Utility.openUrls(context, AppConstants.TG_PAGE);
                              }),*/ /* */ /*
                      ],
                    ),*/ /*
                    right: 10,
                    top: kToolbarHeight,
                  ),
                ),*/
              ],
            ),
          ),
          //Enable Globe in next version
          floatingActionButton: FabCircularMenu(
            key: fabKey,
            ringDiameter: 350,
            ringWidth: 75,
             /*fabOpenIcon: const Icon(
              Icons.language,
              color: Colors.white,
            ),*/

            // fabOpenIcon: Lottie.asset('images/world_map_icon.json',),
            fabOpenIcon: Lottie.asset(
              'images/world_map_icon_new.json',
            ),

            children: <Widget>[
              fabIconButton('images/ttm_fb.png', () {
                Utility.openUrls(context, AppConstants.FB_PAGE);
              }),
              fabIconButton('images/ttm_insta.png', () {
                Utility.openUrls(context, AppConstants.IG_PAGE);
              }),
              fabIconButton('images/ttm_twitter.png', () {
                Utility.openUrls(context, AppConstants.TW_PAGE);
              }),
              fabIconButton('images/ttm_web.png', () {
                Utility.openUrls(context, AppConstants.WEB_PAGE);
              },size: 30),
            ],
            fabSize: 50,
            alignment: Alignment(1, Platform.isIOS ? -0.725 : -0.6),
            fabElevation: 0.0,
            fabColor: AppColors.firstColor.withOpacity(0.0),

            fabCloseIcon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            ringColor: Colors.black.withOpacity(0.65),
          ),
          bottomNavigationBar: Obx(
            () => searchController.isFromPlayList.value
                ? const SizedBox.shrink()
                : BottomNavigation(
                    currentTab: TabItem.home,
                    onSelectTab: (t) {
                     fabKey.currentState!.close();
                      searchController.closeSearchPanel();
                    },
                  ),
          ),
        ),
      ),
    );
  }

  fabIconButton(String s, VoidCallback callback,
      {double size = 40.0}) {
    return IconButton(
        icon: Image.asset(
          s,
          //color: Colors.white,
         /* width: width,
          height: height,*/
        ),iconSize: size,
        onPressed: () {
          fabKey.currentState!.close();
          callback();
        });
  }

  void registerFcmToken(BuildContext context) async {
    AppSharedPreference().getStringData(AppConstants.FCM_TOKEN).then((token) {
      if (token.isNotEmpty) {
        ApiService().postData(ApiKeys.FCM_TOKEN_SUFFIX,
            ApiKeys.getFcmQuery(token, Utility.getDeviceOs()));
      }
    });
  }

  static void playSelectedPodcast(String podcastId) async {

    print('Play Podcast $podcastId');

    if(podcastId.isEmpty) return;

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

    TomTomApp.podcastId = "";

  }

}
