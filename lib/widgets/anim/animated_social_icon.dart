import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';

class AnimatedSocialIcon extends GetView<MainController> {
  final String iconPath;
  final Duration? duration;
  final VoidCallback callback;

  const AnimatedSocialIcon(
      {Key? key, required this.iconPath, this.duration,required this.callback,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedContainer(
        duration: duration ?? const Duration(milliseconds: 300),
        height: controller.showSocialBtns.value == 1.0 ? 50 : 0,
        width: controller.showSocialBtns.value == 1.0 ? 50 : 0,
        padding: const EdgeInsets.only(top: 8.0),
        curve: Curves.linear,
        child: RawMaterialButton(
          onPressed: callback,
          shape: const CircleBorder(),
          fillColor: AppColors.firstColor.withOpacity(0.5),
          child: Image.asset(
            iconPath,color: Colors.white, width: 25,height: 25,
          ),
        ),
      ),
    );
  }
}
