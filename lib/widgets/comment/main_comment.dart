import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/comment_response.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/chat/chat_bubble.dart';
import 'package:podcast_app/screens/main/main_page.dart';
import 'package:podcast_app/screens/sub_screens/report_screen.dart';
import 'package:podcast_app/widgets/audio_clip.dart';
import 'package:podcast_app/widgets/comment/replay_comment.dart';

class MainComment extends GetView<MainController> {
  final Comment comment;

  const MainComment(this.comment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey overFlowKey = GlobalKey();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(
                  comment.commenterImage == null ||
                          comment.commenterImage!.isEmpty
                      ? AppConstants.dummyProfilePic
                      : comment.commenterImage!),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        comment.commenterName!,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          comment.commentDateInago!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  /*comment.commentDescription!.isNotEmpty
                      ? Text(
                          comment.commentDescription!,
                          maxLines: null,
                          style: const TextStyle(color: Colors.white),
                        )
                      : const SizedBox.shrink()*/

                  HtmlWidget(
                    comment.commentDescription!,
                    textStyle: const TextStyle(color: Colors.white),
                    onLoadingBuilder: (context, element, loadingProgress) =>
                        const SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator()),
                    webView: true,
                    customWidgetBuilder: (element) {
                      if (element.localName!.contains("audio") &&
                          element.attributes['src'] != null) {
                        return AudioClip(audioUrl: element.attributes['src']!);
                      }

                      return null;
                    },
                    onTapUrl: (url) {
                      return true;
                    },
                    onTapImage: (imgUrl) {
                      print(imgUrl.sources.first.url);
                      try {
                        showDialog(
                            context: MainPage.activeContext!,
                            barrierDismissible: true,
                            builder: (_) => ImageDialog(
                                  imgUrl: imgUrl.sources.first.url,
                                ));
                      } catch (e) {}
                    },
                  ),
                ],
              ),
            ),
            comment.commenterId == CommonNetworkApi().mobileUserId
                ? Material(
                    color: Colors.transparent,
                    child: IconButton(
                        key: overFlowKey,
                        onPressed: () {
                          showMenu<String>(
                            context: context,
                            // position: RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),
                            position: getPosition(overFlowKey),

                            //position where you want to show the menu on screen
                            items: [
                              PopupMenuItem<String>(
                                  value: '1',
                                  onTap: () {
                                    controller
                                        .deleteComment(comment.commentId!);
                                  },
                                  child: const Text(
                                    'Delete',
                                  )),
                            ],

                            elevation: 8.0,
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        )),
                  )
                : Material(
                    color: Colors.transparent,
                    child: IconButton(
                        key: overFlowKey,
                        onPressed: () {
                          showMenu<String>(
                            context: context,
                            // position: RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),
                            position: getPosition(overFlowKey),

                            //position where you want to show the menu on screen
                            items: [
                              PopupMenuItem<String>(
                                  value: '2',
                                  onTap: () {
                                    //controller.deleteComment(comment.commentId!);

                                    print('clicked report');

                                    openDialog(context, comment.commentId!);

                                    /* await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            title: const Center(
                                child: Text(
                                  "Report on Comment",
                                  style: TextStyle(
                                    color: AppColors.firstColor,
                                    fontSize: 22,
                                  ),
                                  textAlign: TextAlign.center,
                                )),
                            //content: const ReportScreen(),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, AppConstants.CANCEL);
                                      },
                                      child: const Text(
                                        'Dismiss',
                                        style: TextStyle(
                                          color: AppColors.firstColor,
                                          fontSize: 18,
                                        ),
                                      )),

                                ],
                              )
                            ],
                          );
                        });*/
                                  },
                                  child: const Text(
                                    'Report',
                                  )),
                            ],

                            elevation: 8.0,
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        )),
                  ),
          ],
        ),
        Row(
          children: const [
            SizedBox(
              height: 1,
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            IconButton(
              onPressed: () {
                controller.postldh(comment.commentId!, 'like');
              },
              icon: Icon(
                comment.commentYouLiked == "1"
                    ? Icons.thumb_up
                    : Icons.thumb_up_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            Text(
              comment.likecount!,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                controller.postldh(comment.commentId!, 'dislike');
              },
              icon: Icon(
                comment.commentYouDisliked == "1"
                    ? Icons.thumb_down
                    : Icons.thumb_down_alt_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            Text(
              comment.dislikecount!,
              style: const TextStyle(color: Colors.white),
            ),
            /*const SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                controller.postldh(comment.commentId!, 'heart');
              },
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.white,
                size: 20,
              ),
            ),
            Text(
              comment.heartcount!,
              style: const TextStyle(color: Colors.white),
            ),*/
            const SizedBox(
              width: 15,
            ),
            Material(
                color: Colors.transparent,
                child: InkWell(
                    onTap: () {
                      controller.enableReplayEditField.value = true;
                      controller.commentId.value = comment.commentId!;

                      /* showDialog(
                          context: context,

                          builder: (c) {
                            return AlertDialog(
                             // title: const Text('Comment Replay'),
                              backgroundColor: Colors.transparent,
                              insetPadding: EdgeInsets.all(10),
                              content: Container(
                                width: double.infinity,
                                  child: ChatTextField(mainContext: context,)),

                            );
                          });*/
                    },
                    child: const Text(
                      'Add Reply',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ))),
          ],
        ),
        Obx(() => controller.enableReplayEditField.value &&
                controller.commentId.value == comment.commentId!
            ? const ReplayTextField()
            : const SizedBox.shrink()),
        /*comment.replylist!.isNotEmpty
            ? Text(
                '${comment.replylist!.length} Replies',
                style: const TextStyle(
                    color: AppColors.firstColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            : const SizedBox.shrink(),*/
        const SizedBox(
          height: 15,
        ),
        comment.replylist!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListView.builder(
                    itemCount: comment.replylist!.length,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return ReplayComment(
                        reply: comment.replylist![index],
                      );
                    }),
              )
            : const SizedBox.shrink(),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  getPosition(GlobalKey overFlowKey) {
    RenderBox box = overFlowKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position

    return RelativeRect.fromLTRB(position.dx, position.dy + 40, 0.0, 0.0);
  }

  void openDialog(context, String commentId) {
    Future.delayed(const Duration(milliseconds: 500), () {
      showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondAnimation) {
            return ReportScreen(
              id: commentId,
              isPodcast: false,
            );
          });
    });
  }
}

class ReplayTextField extends GetView<MainController> {
  const ReplayTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        decoration: const BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                autofocus: true,
                textAlign: TextAlign.start,
                maxLines: null,
                controller: controller.messageController,
                style: const TextStyle(
                    fontSize: 14.0, color: AppColors.phoneTextColor),
                decoration: const InputDecoration(
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  /*border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.transparent,width: 0.0)
                  ),*/

                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  fillColor: Colors.transparent,
                  alignLabelWithHint: true,
                  hintText: 'Enter reply',
                  counterText: "",
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                onEditingComplete: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  controller.enableReplayEditField.value = false;

                  controller.sendReplyMessage(context);
                },
              ),
            ),
            Material(
                color: Colors.transparent,
                child: IconButton(
                    onPressed: () {
                      if (controller.messageController.text.isNotEmpty) {
                        controller.sendReplyMessage(context);

                        FocusManager.instance.primaryFocus?.unfocus();
                        controller.enableReplayEditField.value = false;
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.firstColor,
                    )))
          ],
        ),
      ),
    );
  }
}
