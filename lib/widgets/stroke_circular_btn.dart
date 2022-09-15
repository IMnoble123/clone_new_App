import 'package:flutter/material.dart';

class StrokeCircularButton extends StatelessWidget {
  final Color? strokeColor;
  final Color? bgColor;
  final double? strokeWidth;
  final double? iconSize;
  final VoidCallback? callback;
  final IconData? iconData;
  final bool disable;

  const StrokeCircularButton(
      {Key? key,
      this.strokeColor,
      this.bgColor,
      this.strokeWidth,
      this.iconSize,
      this.callback,
      this.iconData,
      this.disable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: disable,
      child: Opacity(
        opacity: disable?0.5:1.0,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Material(
              type: MaterialType.transparency,
              //Makes it usable on any background color, thanks @IanSmith
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: strokeColor ?? Colors.white,
                      width: strokeWidth ?? 4.0),
                  color: bgColor ?? Colors.black,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  //This keeps the splash effect within the circle
                  borderRadius: BorderRadius.circular(1000.0),
                  //Something large to ensure a circle
                  onTap: callback,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      iconData ?? Icons.add,
                      size: iconSize ?? 20.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
