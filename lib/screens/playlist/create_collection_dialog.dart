import 'package:flutter/material.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/widgets/btns/wrap_text_btn.dart';

class CreateCollectionDialog extends StatelessWidget {
  const CreateCollectionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width-100,
      color: Colors.red,
      height: 250,
      child: Column(children: [

        WrapTextButton(
          title: 'Cancel',
          callback: () {

            Navigator.pop(context);
          },
          textColor: AppColors.firstColor,
        ),

      ],),
    );
  }
}
