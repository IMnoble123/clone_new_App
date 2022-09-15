import 'package:flutter/material.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/widgets/rj_row_item.dart';

class RjsList extends StatelessWidget {
  final List<RjItem> rjItems;

  const RjsList({Key? key, required this.rjItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (c, i) {
          return RjRowItem(rjItem: rjItems[i]);
        },
        separatorBuilder: (c, i) {
          return const Divider();
        },
        itemCount: rjItems.length);
        // itemCount: rjItems.length>=10?10:rjItems.length);
  }
}
