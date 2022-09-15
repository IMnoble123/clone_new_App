import 'package:flutter/material.dart';

class LinearGradientBg extends StatelessWidget {
  const LinearGradientBg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 54, 0, 0), Colors.black],
              /*colors: [
                Colors.red.withOpacity(0.5),
                Colors.black.withOpacity(0.5)
              ],*/
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.5])),
    );
  }
}
