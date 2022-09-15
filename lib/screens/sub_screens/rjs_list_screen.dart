import 'package:flutter/material.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/widgets/rj_row_item.dart';

class RjsListScreen extends StatelessWidget {
  final String title;
  final List<RjItem> rjItems;

  const RjsListScreen({Key? key, required this.title, required this.rjItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      /*decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover)),*/
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
              itemBuilder: (c, i) {
                return RjRowItem(
                  rjItem: rjItems[i]
                );
              },
              separatorBuilder: (c, i) {
                return const Divider();
              },
              itemCount: rjItems.length>=10?10:rjItems.length),
        ),
      ),
    );
  }
}
