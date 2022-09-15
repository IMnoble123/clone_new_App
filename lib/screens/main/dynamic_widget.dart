import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/keys.dart';
import 'package:podcast_app/screens/dash_board.dart';
import 'package:podcast_app/widgets/tab_navigator.dart';

class DynamicWidget extends StatelessWidget {
  const DynamicWidget({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final mainController = Get.find<MainController>();


    return Obx(
      () => TabNavigator(
        key: GlobalKey<NavigatorState>(),
        name: mainController.tabName.value,
      ),
    );
  }



}
