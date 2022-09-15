import 'package:flutter/material.dart';

class MenusTitle extends StatelessWidget {
  final String text;
  final double? size;
  final Color? color;

  const MenusTitle({Key? key, required this.text, this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: size ?? 20,
          color: color ?? Colors.white,
          fontWeight: FontWeight.w600),
    );
  }
}
