import 'package:flutter/material.dart';
import 'package:podcast_app/extras/app_colors.dart';

class StadiumButton extends StatelessWidget {
  final VoidCallback? callback;
  final String? title;
  final Color? bgColor;
  const StadiumButton({Key? key, this.callback, this.title, this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: callback,
      color: bgColor ?? AppColors.firstColor,
      shape: const StadiumBorder(),
      child: Text(
        title ?? '',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
