import 'package:flutter/material.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/comment_response.dart';

import 'package:flutter/material.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/models/response/comment_response.dart';
import 'package:podcast_app/screens/video_screen.dart';

class CommentItem extends StatelessWidget {
  final Comment commentItem;
  const CommentItem({Key? key, required this.commentItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (commentItem.filepath != null && commentItem.filepath!.isNotEmpty) {
      switch (commentItem.filepath!.split('.').last.toLowerCase()) {
        case 'jpeg':
        case 'jpg':

          child = ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                commentItem.filepath!,
                fit: BoxFit.cover,
                errorBuilder: (ctx, child, _) => const Center(
                  child:  Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          );
          break;
        case 'mp4':
          child = VideoApp(url: commentItem.filepath!);
          break;
        default:
          child = Text('loading...');
      }
    } else {
      child = Text(
        commentItem.commentDescription ?? '',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
      );
    }
    return Container(
      //height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                commentItem.commenterName ?? ''.toUpperCase(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                commentItem.commentDateInago ?? '',
                style: TextStyle(
                  color: AppColors.disableColor,
                ),
              )
            ],
          ),
          child,
        /*  Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border_rounded,
                    color: AppColors.inActiveColor,
                  )),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.message_rounded,
                    color: AppColors.inActiveColor,
                  )),
              Text(
                '${commentItem.replyComments != null ? commentItem.replyComments!.length : '0'} replys',
                style: TextStyle(
                  color: AppColors.disableColor,
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.inActiveColor,
                  )),
            ],
          ),*/
          // Divider(
          //   color: AppColors.inActiveColor,
          //   height: 0.5,
          // )
        ],
      ),
    );
  }
}
