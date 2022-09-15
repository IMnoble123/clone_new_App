import 'package:flutter/material.dart';
import 'package:podcast_app/extras/app_colors.dart';

class TitleTileView extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final VoidCallback? callback;
  final bool? isEditable;

  const TitleTileView(
      {Key? key,
      this.title,
      this.subTitle,
      this.callback,
      this.isEditable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
                if (subTitle != null)
                  Text(
                    subTitle ?? '',
                    style: const TextStyle(color: AppColors.textSecondaryColor),
                  ),
              ],
            ),
          ),
          if (isEditable!)
            TextButton(
              onPressed: callback,
              child: const Text(
                'Edit',
                style: TextStyle(color: Colors.red),
              ),
            )
        ],
      ),
    );
  }
}
