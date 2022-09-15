import 'package:flutter/material.dart';
import 'package:podcast_app/widgets/bg/clip_shadow_path.dart';
import 'package:podcast_app/widgets/bg/curved_clipper.dart';

class TomTomTitle extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final bool hideTitle;
  const TomTomTitle({Key? key, required this.title, this.width=100, this.height=100, this.hideTitle=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipShadowPath(
        shadow: BoxShadow(
          color: Colors.red.withOpacity(0.25),
          offset: const Offset(0.0, 15.0),
          blurRadius: 25.0,
        ),
        clipper: CurvedClipper(),
        child: Container(
          height: 250,
          width: double.infinity,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/tomtom_new.png',
                width: width,
                height: height,
                scale: 2,
              ),
               hideTitle?const SizedBox.shrink():Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text(
                   title,
                   style: const TextStyle(
                       color: Colors.white,
                       fontSize: 18,
                       fontWeight: FontWeight.w600),
                 ),
               ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ));
  }
}
