import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';

class PlayListChips extends GetView<PlayListController> {
  const PlayListChips({Key? key}) : super(key: key);

  static final List<String> chipsTitles = [
    'All Playlists',
    'Downloads',
    'Listen Later',
    'Subscriptions',
    'Favourites',
    'History'
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Theme(
        data: ThemeData(canvasColor: Colors.transparent),
        child: ListView.separated( scrollDirection: Axis.horizontal,
            itemBuilder: (c, i) {
              return chipItem(chipsTitles[i], i);
            },
            separatorBuilder: (c, i) {
              return const SizedBox(width: 5,);
            },
            itemCount: chipsTitles.length),
      ),
    );
  }

  chipItem(String s, int chipIndex) {
    return Obx(
      ()=> ChoiceChip(
        label: Text(
          s,
          style: const TextStyle(color: Colors.white),
        ),
        selected: controller.chipSelectedIndex.value == chipIndex,
        selectedColor: Colors.white.withOpacity(0.2),
        backgroundColor: Colors.white.withOpacity(0.2),
        shape: controller.chipSelectedIndex.value == chipIndex
            ? const StadiumBorder(side: BorderSide(color: AppColors.firstColor))
            : null,
        onSelected: (selected) {
          controller.updateChipSelectedIndex(chipIndex);
        },
      ),
    );
  }
}
