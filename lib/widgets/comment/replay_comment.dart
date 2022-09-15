import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/comment_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/screens/chat/chat_bubble.dart';
import 'package:podcast_app/widgets/audio_clip.dart';

import '../../screens/sub_screens/report_screen.dart';

class ReplayComment extends StatelessWidget {
  final Reply reply;

  const ReplayComment({Key? key, required this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GlobalKey overFlowKey = GlobalKey();

    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundImage: CachedNetworkImageProvider(
                    reply.replyerImage == null || reply.replyerImage!.isEmpty
                        ? AppConstants.dummyProfilePic
                        : reply.replyerImage!),
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
                          reply.replyerName!,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: Text(
                            reply.replyDateInago!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    /* reply.replyerDescription!.isNotEmpty
                        ? Text(
                      reply.replyerDescription!,maxLines: null,
                      style: const TextStyle(color: Colors.white),
                    )
                        : const SizedBox.shrink(),*/
                    HtmlWidget(
                      reply.replyerDescription!,
                      textStyle: const TextStyle(
                        color: Colors.white,
                      ),
                      customWidgetBuilder: (element) {
                        if (element.localName!.contains("audio") &&
                            element.attributes['src'] != null) {
                          return AudioClip(
                              audioUrl: element.attributes['src']!);
                        }

                        return null;
                      },
                      onTapUrl: (url) {
                        return true;
                      },
                      onTapImage: (imgUrl) {
                        print(imgUrl.sources.first.url);
                        showDialog(
                            context: context,
                            builder: (_) => ImageDialog(
                                  imgUrl: imgUrl.sources.first.url,
                                ));
                      },
                    ),
                    /*SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: HtmlWidget(
                        reply.replyerDescription!,
                        textStyle: const TextStyle(color: Colors.white,),
                      ),
                    )*/
                  ],
                ),
              ),
              reply.replyerId == CommonNetworkApi().mobileUserId
                  ? Material(
                color: Colors.transparent,
                    child: IconButton(
                        key: overFlowKey,
                        onPressed: () async {
                          print('clicked');

                          showMenu<String>(
                            context: context,
                            // position: RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),
                            position: getPosition(overFlowKey),

                            //position where you want to show the menu on screen
                            items: [
                               PopupMenuItem<String>(
                                  child: const Text('Delete',), value: '1',onTap: (){

                                 Get.find<MainController>().deleteReply(reply.replyId!);

                              }),

                            ],

                            elevation: 8.0,
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        )),
                  )
                  :const SizedBox.shrink() /*Material(
                color: Colors.transparent,
                child: IconButton(
                    key: overFlowKey,
                    onPressed: () async {
                      print('clicked');

                      showMenu<String>(
                        context: context,
                        // position: RelativeRect.fromLTRB(25.0, 25.0, 0.0, 0.0),
                        position: getPosition(overFlowKey),

                        //position where you want to show the menu on screen
                        items: [
                          PopupMenuItem<String>(
                              child: const Text('Report',), value: '1',onTap: (){

                           // Get.find<MainController>().deleteReply(reply.replyId!);

                            openDialog(context,reply.replyId!);

                          }),

                        ],

                        elevation: 8.0,
                      );
                    },
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    )),
              ),*/
            ],
          ),
         /* Row(
            children: const [
              SizedBox(
                height: 5,
              ),
            ],
          ),*/
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.find<MainController>().replayLDH(reply.replyId!, 'like');
                },
                icon:  Icon(
                  reply.replyYouLiked =="1"? Icons.thumb_up :Icons.thumb_up_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Text(
                reply.likecount!,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  Get.find<MainController>()
                      .replayLDH(reply.replyId!, 'dislike');
                },
                icon:  Icon(
                  reply.replyYouDisliked =="1"? Icons.thumb_down :Icons.thumb_down_alt_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Text(
                reply.dislikecount!,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),
              /*IconButton(
                onPressed: () {
                  Get.find<MainController>().replayLDH(reply.replyId!, 'heart');
                },
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Text(
                reply.heartcount!,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(
                width: 10,
              ),*/
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  getPosition(GlobalKey overFlowKey) {

    RenderBox box = overFlowKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position

    return RelativeRect.fromLTRB(position.dx, position.dy+40, 0.0, 0.0);


  }

  void openDialog(context, String replyId) {



    Future.delayed(const Duration(milliseconds: 500),(){

      showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondAnimation) {
            return  ReportScreen(id: replyId, isPodcast: false);
          });

    });




  }



}
