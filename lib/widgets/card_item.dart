import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardItem extends StatelessWidget {
  final String? imgUrl;
  final String? title;
  final VoidCallback? tapCallback;

  const CardItem({Key? key, this.imgUrl, this.tapCallback, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 10,
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl:imgUrl!,
                // 'https://stilearning.com/vision/assets/globals/img/dummy/img-10.jpg',
            fit: BoxFit.cover,
          ),
          Positioned(
            child: Container(
              color: Colors.black26,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  title!,
                  overflow: TextOverflow.ellipsis,
                  style:
                      GoogleFonts.slabo27px(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            bottom: 0,
            left: 0,
            right: 0,
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: tapCallback,
            ),
          ))
        ],
      ),
    );
  }
}
