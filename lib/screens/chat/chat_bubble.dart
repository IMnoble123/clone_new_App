import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/widgets/audio_clip.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.isCurrentUser,
  }) : super(key: key);
  final String text;
  final bool isCurrentUser;

  // static String temp = "<audio controls preload=\"auto\">\n        <source src=\"https://du9p41coy5gm0.cloudfront.net/1649334529_file_example_MP3_700KB.mp3\" type=\"audio/mpeg\">\n        <source src=\"https://du9p41coy5gm0.cloudfront.net/1649334529_file_example_MP3_700KB.mp3\" type=\"audio/ogg\">\n        Your browser does not support the audio element.\n    </audio>";
  // static String temp = " <!DOCTYPE html> <html> <body> <audio src=\"https://du9p41coy5gm0.cloudfront.net/1649334529_file_example_MP3_700KB.mp3\" controls preload=\"auto\" type=\"audio/mpeg\"></audio> <audio src=\"https://du9p41coy5gm0.cloudfront.net/1649334529_file_example_MP3_700KB.mp3\" controls preload=\"auto\" type=\"audio/mpeg\"></audio> </body> </html>";

  static const htmlData =
      r"""<audio src=\"https://du9p41coy5gm0.cloudfront.net/1649402807_file_example_MP3_700KB.mp3\" controls preload=\"auto\" type=\"audio/mpeg\"></audio>""";

  static String temp =
      "<audio src=\"https://du9p41coy5gm0.cloudfront.net/1649334529_file_example_MP3_700KB.mp3\" controls preload=\"auto\" type=\"audio/mpeg\"></audio>";

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser
                ? AppColors.firstColor.withOpacity(0.3)
                : Colors.blue.withOpacity(0.25),
            // color: text.contains('<audio')?Colors.transparent:isCurrentUser ? AppColors.firstColor : Colors.blue,
            // color: getColor(text, isCurrentUser),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
            child: HtmlWidget(
              // data: text.contains("\'")?json.decode(text):text,
              // temp,
              text, textStyle: const TextStyle(color: Colors.white),
              customWidgetBuilder: (element) {
                /*if (element.contains(Node.ATTRIBUTE_NODE)) {
                  return NoDataWidget();
                }*/

                if (element.localName!.contains("audio") &&
                    element.attributes['src'] != null) {
                  // Widget widget = (obj) => AudioClip(key: ObjectKey(obj), audioUrl: element.attributes['src']!);

                  return AudioClip(audioUrl: element.attributes['src']!);
                }

                /*if (element.localName!.contains("audio")) {
                  return element.attributes['src'] != null
                      ?  AudioClip(key: ObjectKey(element.attributes['src']), audioUrl: element.attributes['src']!)
                      : null;
                }*/

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
            /*child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: isCurrentUser ? Colors.white : Colors.black),
            ),*/
          ),
        ),
      ),
    );
  }

  getColor(String text, bool isCurrentUser) {
    if (text.contains('<audio')) {
      if (isCurrentUser) {
        return AppColors.firstColor.withOpacity(0.25);
      } else {
        return Colors.blue.withOpacity(0.25);
      }
    } else {
      if (isCurrentUser) {
        return AppColors.firstColor;
      } else {
        return Colors.blue;
      }
    }
  }
}

class ImageDialog extends StatelessWidget {
  final String imgUrl;

  const ImageDialog({Key? key, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      key: GlobalKey(),
      child: Stack(
        children: [

          Container(
            /*decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(imgUrl),
                  fit: BoxFit.contain
              )
          ),*/
            color: Colors.transparent,
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imgUrl),
            ),
          ),

          Positioned(
            right: 0.0,
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: const Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  radius: 14.0,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.close, color: AppColors.firstColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
