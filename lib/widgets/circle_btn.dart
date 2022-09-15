import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color? color;
  final VoidCallback? tapCallback;

  const CircleButton(
      {Key? key,
      required this.child,
      this.width,
      this.height,
      this.color,
      this.tapCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 50,
      height: height ?? 50,
      child: RawMaterialButton(
        onPressed: tapCallback != null
            ? () {
                tapCallback!();
              }
            : null,

        shape: const CircleBorder(),
        child: child,
      ),
      /*child: RawMaterialButton(
        onPressed: tapCallback != null
            ? () {
                tapCallback!();
              }
            : null,
        fillColor: color ?? const Color.fromARGB(255, 186, 16, 19),
        padding: const EdgeInsets.all(15.0),
        shape: const CircleBorder(),
        child: child,
      ),*/
    );

    /*return Stack(
      children: [
        Container(
          width: width ?? 50,
          height: height ?? 50,
          decoration: BoxDecoration(
              color: color ?? const Color.fromARGB(255, 186, 16, 19),
              shape: BoxShape.circle),
          child: child,
        ),
        Positioned.fill(
            child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Theme.of(context).primaryColor.withOpacity(0.4),
            onTap: tapCallback != null
                ? () {
                    tapCallback!();
                  }
                : null,
          ),
        ))
      ],
    );*/
  }
}
