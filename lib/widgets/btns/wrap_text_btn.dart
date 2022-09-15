import 'package:flutter/material.dart';
import 'package:podcast_app/extras/app_colors.dart';

class WrapTextButton extends StatelessWidget {
  final VoidCallback? callback;
  final String? title;
  final Color? textColor;
  final bool boldText;
  final bool singleLine;

  const WrapTextButton(
      {Key? key,
      this.callback,
      this.title,
      this.textColor,
      this.boldText = false,
      this.singleLine = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: callback,
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft),
        child: Text(
          title ?? '',
          overflow: singleLine?TextOverflow.ellipsis:TextOverflow.visible,
          style: TextStyle(
              color: textColor ?? AppColors.firstColor,
              fontWeight: boldText ? FontWeight.bold : FontWeight.normal),
        ));
  }
}
