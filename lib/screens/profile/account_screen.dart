import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/profile_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/widgets/title_tile_view.dart';

class AccountScreen extends GetView<ProfileController> {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Account',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(
                width: 150,
                child: Divider(
                  color: AppColors.disableColor,
                )),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                /* primary: false,
                shrinkWrap: true,*/

                children: [
                  TitleTileView(
                    title: 'User Name',
                    subTitle: controller.userData.value.name??'',
                    callback: () {},
                    isEditable: false,
                  ),
                  TitleTileView(
                    title: 'Email',
                    subTitle: controller.userData.value.email??'',
                    callback: () {},
                    isEditable: false,
                  ),
                 /* TitleTileView(
                    title: 'Subscription',
                    subTitle: 'Free',
                    callback: () {},
                    isEditable: false,
                  ),*/
                  /*Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Premium',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'What is premium With TOMTOM Premium you’ll enjoy full access to our podcast catalog, With none of restrictions. No limits, No Ads, No Hassle. Just podcasts. \n\nTo close (delete) your account permanently contact customer support.',
                        style: TextStyle(color: AppColors.textSecondaryColor),
                      ),
                    ],
                  ),*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
