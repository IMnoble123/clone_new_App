import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/widgets/comment/main_comment.dart';

class MainCommentsScreen extends GetView<MainController> {
  const MainCommentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.comments.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              primary: false,
              separatorBuilder: (context,index){
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(height: 1,color: Colors.white70,),
                );
              },
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(5.0),
                    /*decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                            color: AppColors.disableColor, width: 0.5)),*/
                    child: MainComment(controller.comments[index]));
              },
              itemCount: controller.comments.length,
            )
          : const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('No Comments',style: TextStyle(color: Colors.white),),
          ),
    );
  }
}
