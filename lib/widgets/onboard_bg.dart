import 'package:flutter/material.dart';

class OnboardBgWidget extends StatelessWidget {
  final Widget? child;

  const OnboardBgWidget({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover)),
      child: child ?? const SizedBox.shrink(),
    );
  }
}
