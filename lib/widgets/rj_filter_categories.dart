import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';

class RjFilterCategories extends GetView<MainController> {
  final String rjId;
  final VoidCallback callback;

  const RjFilterCategories(this.rjId, this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchRjsFilterCategories(rjId);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        child: Obx(
          () => Theme(
            data: ThemeData(canvasColor: Colors.transparent),
            child: controller.filteredRjCategories.isNotEmpty
                ? ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Obx(
                        ()=> ChoiceChip(
                            label: Text(
                              controller.filteredRjCategories[index].category!,
                              style: const TextStyle(color: Colors.white),
                            ),
                            selectedColor: Colors.white.withOpacity(0.2),
                            backgroundColor: Colors.white.withOpacity(0.2),
                            shape: controller.rjChipSelectedIndex.value == index
                                ?  const StadiumBorder(
                                side: BorderSide(
                                    color: AppColors.firstColor))
                                : null,

                            onSelected: (selected) {
                              controller.rjChipSelectedIndex.value = index;
                              controller.rjPodcastFilter.value = controller.filteredRjCategories[index].category!;
                              callback();
                            },
                            selected: controller.rjChipSelectedIndex.value==index),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        width: 10,
                      );
                    },
                    itemCount: controller.filteredRjCategories.length)
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
