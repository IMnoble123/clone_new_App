import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/keys.dart';

enum TabItem { home, playList, tomTom, profile }

Map<TabItem, String> tabName = {
  TabItem.home: 'Home',
  TabItem.playList: 'PlayList',
  TabItem.tomTom: 'TomTom',
  TabItem.profile: 'Profile',
};

Map<TabItem, Color> activeTabColor = {
  TabItem.home: Colors.white,
  TabItem.playList: Colors.white,
  TabItem.tomTom: Colors.white,
  TabItem.profile: Colors.white,
};

class BottomNavigation extends GetView<MainController> {
  const BottomNavigation(
      {Key? key, required this.currentTab, required this.onSelectTab})
      : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return Obx(
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
          /*BottomNavigationBarItem(
            icon: Obx(
              () => Opacity(
                opacity: controller.selectedIndex.value == 2 ? 1.0 : 0.75,
                child: Image.asset(
                  'images/tom_tom.png',
                  width: 35,
                ),
              ),
            ),
            label: 'Media',
          ),*/
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('images/profile_icon.png'),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: controller.selectedIndex.value,
        onTap: (i) {
          print(i);
          onSelectTab(
            TabItem.values[i],
          );
          controller.updateSelectedIndex(i);
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.firstColor,
        iconSize: 20,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.firstColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(color: Colors.grey, fontSize: 22),
        //selectedLabelStyle: TextStyle(color: Colors.white),
        items: [
          _buildItem(tabItem: TabItem.home, assetPath: 'images/home_icon.png'),
          _buildItem(
              tabItem: TabItem.playList,
              assetPath: 'images/play_list_icon.png'),
          _buildItem(tabItem: TabItem.tomTom, assetPath: 'images/tom_tom.png'),
          _buildItem(
              tabItem: TabItem.profile, assetPath: 'images/profile_icon.png'),
        ],
        onTap: (index) => onSelectTab(
          TabItem.values[index],
        ),
      );
  }*/

  BottomNavigationBarItem _buildItem(
      {required TabItem tabItem, required String assetPath}) {
    String? text = tabName[tabItem];
    return BottomNavigationBarItem(
      icon: ImageIcon(
        AssetImage(assetPath),
        color: _colorTabMatching(item: tabItem),
      ) /*Icon(
        icon,
        color: _colorTabMatching(item: tabItem),
      )*/
      ,
      label: text,
    );
  }

  Color? _colorTabMatching({required TabItem item}) {
    // return currentTab == item ? activeTabColor[item] : Colors.white54;
    return currentTab == item ? Colors.white : Colors.white54;
  }
}
