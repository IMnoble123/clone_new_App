import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/profile_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';

class NotificationsScreen extends GetView<ProfileController> {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Notifications',
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
              const Text(
                'New Podcasts',
                style: TextStyle(color: Colors.white),
              ),
              const Text(
                'Hear about Podcasts you listen to and Podcasts we think you’ll like',
                style: TextStyle(color: AppColors.textSecondaryColor),
              ),
              Obx(
                () => SwitchListTile(
                  title: const Text(
                    'Push',
                    style: TextStyle(color: AppColors.iconColor),
                  ),
                  value: controller.isPodcastPushOff.value,
                  inactiveTrackColor: AppColors.iconColor,
                  onChanged: (bool value) {
                    controller.updatePodcastPush(value);
                  },
                ),
              ),
              Obx(
                () => SwitchListTile(
                  title: const Text(
                    'Email',
                    style: TextStyle(color: AppColors.iconColor),
                  ),
                  value: controller.isPodcastEmailOff.value,
                  inactiveTrackColor: AppColors.iconColor,
                  onChanged: (bool value) {
                    controller.updatePodcastEmail(value);
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'New RJs',
                style: TextStyle(color: Colors.white),
              ),
              const Text(
                'Hear about RJs you listen to and RJs we think you’ll like',
                style: TextStyle(color: AppColors.textSecondaryColor),
              ),
              Obx(
                () => SwitchListTile(
                  title: const Text(
                    'Push',
                    style: TextStyle(color: AppColors.iconColor),
                  ),
                  value: controller.isRjPushOff.value,
                  inactiveTrackColor: AppColors.iconColor,
                  onChanged: (bool value) {
                    controller.updateRjPush(value);
                  },
                ),
              ),
              Obx(
                () => SwitchListTile(
                  title: const Text(
                    'Email',
                    style: TextStyle(color: AppColors.iconColor),
                  ),
                  value: controller.isRjEmailOff.value,
                  inactiveTrackColor: AppColors.iconColor,
                  onChanged: (bool value) {
                    controller.updateRjEmail(value);
                  },
                ),
              ),
              const SizedBox(height: 150,)
            ],
          ),
        ),
      ),
    );
  }
}
