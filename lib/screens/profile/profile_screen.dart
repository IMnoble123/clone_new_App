import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/controllers/profile_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/widgets/menus_title.dart';

import '../login/login_screen.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchProfileInfo();

    MainPage.activeContext = context;

    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.firstColor,
                    width: 2.0,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Obx(
                        () =>
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(
                              controller.userData.value.profileImage != null &&
                                  controller
                                      .userData.value.profileImage!.isNotEmpty
                                  ? controller.userData.value.profileImage!
                                  : AppConstants.dummyProfilePic),
                          radius: 55,
                        ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CommonNetworkApi().mobileUserId == "-1"
                  ? const MenusTitle(
                text: 'Welcome Guest',
                size: 16,
              )
                  : Obx(
                    () =>
                    MenusTitle(
                      text: 'Welcome ${controller.userData.value.name}',
                      size: 16,
                    ),
              ),
              TextButton(
                onPressed: () {
                  if (CommonNetworkApi().mobileUserId == "-1") {
                    gotoLoginScreen();
                    return;
                  }

                  Navigator.of(context).pushNamed(AppRoutes.editProfileScreen);
                },
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(50, 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    alignment: Alignment.centerLeft),
                child: Text(
                  CommonNetworkApi().mobileUserId == "-1"
                      ? 'Register Now'
                      : 'Edit profile',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                  width: 150,
                  child: Divider(
                    color: AppColors.disableColor,
                  )),
              const SizedBox(
                height: 20,
              ),
              IgnorePointer(
                ignoring: CommonNetworkApi().mobileUserId == "-1",
                child: Opacity(
                  opacity: CommonNetworkApi().mobileUserId == "-1" ? 0.35:1.0,
                  child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    itemExtent: 40,
                    children: [
                      listTile('Account', () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.accountProfileScreen);
                      }),
                      listTile('Settings', () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.settingsProfileScreen);
                      }),
                      listTile('Notifications', () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.notificationsProfileScreen);
                      }),
                      listTile('Logout', () {
                        Navigator.of(context)
                            .pushNamed(AppRoutes.logoutProfileScreen);
                      }),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

/*@override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover)),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: CircleAvatar(
              backgroundColor: AppColors.firstColor,
              radius: 58,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                    'https://www.postplanner.com/hs-fs/hub/513577/file-2886416984-png/blog-files/facebook-profile-pic-vs-cover-photo-sq.png?width=250&height=250&name=facebook-profile-pic-vs-cover-photo-sq.png'),
                radius: 55,
              ),
            ),
          ),
          const MenusTitle(text: 'Hemanth'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 30,
              child: MaterialButton(
                onPressed: () {},
                shape: StadiumBorder(side: const BorderSide(color: Colors.white)),
                child: const Text(
                  'Edit profile',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                '10\n Followers',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                '2\n Following',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }*/

  listTile(String title, VoidCallback callback) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: callback,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  void gotoLoginScreen() async {
    Get
        .find<MainController>()
        .tomtomPlayer
        .dispose();
    MainPage.isFirstBuild = true;
    await Get.delete<MainController>(force: true)
        .then((value) => Get.offAll(const LoginScreen()));
  }

}
