import 'package:flutter/material.dart';

class NoErrorWidget extends StatelessWidget {
  const NoErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        'from back',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}