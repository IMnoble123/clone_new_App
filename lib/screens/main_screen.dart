import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/search_controller.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/keys.dart';
import 'package:podcast_app/screens/dash_board.dart';
import 'package:podcast_app/screens/playlist/play_list_screen.dart';
import 'package:podcast_app/screens/profile/profile_screen.dart';
import 'package:podcast_app/screens/search_screen.dart';
import 'package:podcast_app/screens/slide_up_screen.dart';
import 'package:podcast_app/screens/tom_tom_screen.dart';
import 'package:podcast_app/widgets/bottom_navigation.dart';
import 'package:podcast_app/widgets/search_widget.dart';
import 'package:podcast_app/widgets/tab_navigator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'collapsed_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const List<Widget> _pages = <Widget>[
    DashBoardScreen(),
    PlayListScreen(),
    TomTomScreen(),
    ProfileScreen()
  ];

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  final controller = Get.find<MainController>();



  TabItem currentTab = TabItem.home;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.playList: GlobalKey<NavigatorState>(),
    TabItem.tomTom: GlobalKey<NavigatorState>(),
    TabItem.profile: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, TabNavigator> tabNavigators = {
    TabItem.home: TabNavigator(
      key: GlobalKey<NavigatorState>(),
      name: 'home',
    ),
    TabItem.playList: TabNavigator(
      key: GlobalKey<NavigatorState>(),
      name: 'playList',
    ),
    TabItem.tomTom: TabNavigator(
      key: GlobalKey<NavigatorState>(),
      name: 'tomTom',
    ),
    TabItem.profile: TabNavigator(
      key: GlobalKey<NavigatorState>(),
      name: 'profile',
    )
  };

  void _selectTab(TabItem tabItem) {
    setState(() {
      controller.updateSearchToggle(false);
      currentTab = tabItem;

      //controller.updateSelectedIndex(3);
    });
  }

  final searchController = Get.find<SearchController>();

  @override
  void initState() {
    super.initState();
    print("init!!!!!!!");
    Future.delayed(const Duration(seconds: 1), () {
      controller.panelController.hide();
    });
  }

  final slideUp = const SlideUpScreen();

  @override
  Widget build(BuildContext context) {
    print("called!!!!!!!");
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: AppKeys.searchTfKey,
        body: SlidingUpPanel(
          backdropTapClosesPanel: true,
          controller: controller.panelController,
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: AssetImage('images/ob_bg.png'),
                        fit: BoxFit.cover)),
              ),
              Column(
                children: [
                  if (controller.selectedIndex.value == 0 ||
                      controller.selectedIndex.value == 1)
                    SearchWidget(() {
                      setState(() {
                        controller.updateSearchToggle(true);
                      });
                    }),

                  //Obx(() => !controller.hideTopSection.value?const SearchWidget():const SizedBox.shrink()),

                  Expanded(
                      child: Obx(
                        ()=> Visibility(
                          visible: controller.isSearchOpened.isFalse,
                          child: Stack(
                    children: [
                          _buildOffstageNavigator(TabItem.home, 'home'),
                          _buildOffstageNavigator(TabItem.playList, 'playList'),
                          _buildOffstageNavigator(TabItem.tomTom, 'tomTom'),
                          _buildOffstageNavigator(TabItem.profile, 'profile'),
                    ],
                  ),
                        ),
                      )
                      //: const SearchScreen(),
                      ),

                  const SizedBox(
                    height: AppConstants.collapseBarHeight,
                  )
                ],
              ),
              Obx(() => controller.isSearchOpened.value
                  ? const SearchScreen()
                  : const SizedBox.shrink()),
            ],
          ),
          panel: slideUp,
          minHeight: 75,
          maxHeight: MediaQuery.of(context).size.height,
          collapsed: const CollapsedScreen(
              // controller: controller,
              ),
        ),
        bottomNavigationBar: BottomNavigation(
          currentTab: currentTab,
          onSelectTab: _selectTab,
        ),
      ),
    );
  }

  _buildOffstageNavigator(TabItem tabItem, String tabName) {
    try {
      if (controller.panelController.isPanelOpen) {
        controller.panelController.close();
      }
    } catch (e) {}

    /*switch (tabItem) {
      case TabItem.home:
        controller.updateHideTop(false);
        break;
      case TabItem.playList:
        controller.updateHideTop(false);
        break;
      case TabItem.tomTom:
        controller.updateHideTop(true);
        break;
      case TabItem.profile:
        controller.updateHideTop(true);
        break;
    }*/

    return Offstage(
      offstage: currentTab != tabItem,
      child: TabNavigator(
        key: GlobalKey<NavigatorState>(),
        name: tabName,
      ),
    );

    /*return Offstage(
      offstage: currentTab != tabItem,
      child: tabNavigators[tabItem],
    );*/
  }

/*_buildOffstageNavigator(TabItem tabItem, String tabName) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: TabNavigator(
        navigatorKey: navigatorKeys[tabItem],
        name: tabName,
      ),
    );
  }*/

/*@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                      image: AssetImage('images/ob_bg.png'),
                      fit: BoxFit.cover)),
            ),
            Column(
              children: [
                const SearchWidget(),
                Expanded(
                  child: Obx(
                      () => MainScreen._pages.elementAt(controller.selectedIndex.value)),
                )
              ],
            )
          ],
        ),
        panel: const SlideUpScreen(),
        minHeight: 50,
        maxHeight: MediaQuery.of(context).size.height,
        collapsed: const CollapsedScreen(),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('images/home_icon.png'),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('images/play_list_icon.png'),
              ),
              label: 'Play list',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('images/tom_tom.png'),
              ),
              label: 'TomTom',
            ),
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage('images/profile_icon.png'),
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          onTap: (i) {
            controller.updateSelectedIndex(i);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.firstColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.5),
          showUnselectedLabels: true,
        ),
      ),
    );
  }*/
}
