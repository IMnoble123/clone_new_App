import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/models/response/comment_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/comment_widget.dart';

class CommentsScreen extends GetView<MainController> {
  const CommentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Obx(() => controller.comments.value.isNotEmpty
            ? updateCommentsData(controller.comments.value)
            : const Text(
                'No Comments',
                style: TextStyle(color: Colors.white),
              ))
      ],
    );
  }

  Widget updateCommentsData(List<Comment> comments) {
    return ListView.separated(
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return CommentItem(
            commentItem: comments[index],
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: comments.length);
  }
}
