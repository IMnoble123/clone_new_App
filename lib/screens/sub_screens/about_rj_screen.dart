import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/models/response/rj_response.dart';

import '../../utils/utility.dart';

class AboutRjScreen extends StatelessWidget {
  final RjItem rjItem;

  const AboutRjScreen({Key? key, required this.rjItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                    size: 30,
                  )),
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          //height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //const Spacer(),
                const Text(
                  'About RJ',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                    width: 150,
                    child: Divider(
                      color: AppColors.disableColor,
                    )),

                const Divider(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Name : ${rjItem.rjName ?? ''}',
                      style: const TextStyle(
                          color: AppColors.textSecondaryColor, fontSize: 12),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'DOB : ${rjItem.rjDob ?? ''}',
                      style: const TextStyle(
                          color: AppColors.textSecondaryColor, fontSize: 12),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      rjItem.aboutme ?? '',
                      style: const TextStyle(
                          color: AppColors.textSecondaryColor, fontSize: 12),
                    ),
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'RJ’s Social Media Network',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                    width: 250,
                    child: Divider(
                      color: AppColors.disableColor,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    itemExtent: 50,
                    children: [
                      listTile('Facebook', () {



                        if (rjItem.facebook != null && rjItem.facebook!.isNotEmpty &&
                                Uri.parse(rjItem.facebook!).host == ''
                            ? false
                            : true) {
                          Utility.openUrls(context, rjItem.facebook??'');
                        } else {
                          Utility.showSnackBar(context, 'invalid link');
                        }

                      },rjItem.facebook != null && rjItem.facebook!.isNotEmpty ),

                      listTile('Twitter', () {

                        if (rjItem.twitter != null && rjItem.twitter!.isNotEmpty &&
                            Uri.parse(rjItem.twitter!).host == ''
                            ? false
                            : true) {
                          Utility.openUrls(context, rjItem.twitter??'');
                        } else {
                          Utility.showSnackBar(context, 'invalid link');
                        }

                      },rjItem.twitter != null && rjItem.twitter!.isNotEmpty),

                      // listTile('Snapchat', () {
                      listTile('Instagram', () {

                        if (rjItem.snapchat != null && rjItem.snapchat!.isNotEmpty &&
                            Uri.parse(rjItem.snapchat!).host == ''
                            ? false
                            : true) {
                          Utility.openUrls(context, rjItem.snapchat??'');
                        } else {
                          Utility.showSnackBar(context, 'invalid link');
                        }

                      },rjItem.snapchat != null && rjItem.snapchat!.isNotEmpty),

                      listTile('Linked in', () {

                        if (rjItem.linkedin != null && rjItem.linkedin!.isNotEmpty &&
                            Uri.parse(rjItem.linkedin!).host == ''
                            ? false
                            : true) {
                          Utility.openUrls(context, rjItem.linkedin??'');
                        } else {
                          Utility.showSnackBar(context, 'invalid link');
                        }

                      },rjItem.linkedin != null && rjItem.linkedin!.isNotEmpty ),

                      listTile('Blogger', () {

                        if (rjItem.blogger != null && rjItem.blogger!.isNotEmpty &&
                            Uri.parse(rjItem.blogger!).host == ''
                            ? false
                            : true) {
                          Utility.openUrls(context, rjItem.blogger??'');
                        } else {
                          Utility.showSnackBar(context, 'invalid link');
                        }


                      },rjItem.blogger != null && rjItem.blogger!.isNotEmpty),

                      listTile('Telegram', () {

                        if (rjItem.telegram != null && rjItem.telegram!.isNotEmpty &&
                            Uri.parse(rjItem.telegram!).host == ''
                            ? false
                            : true) {
                          Utility.openUrls(context, rjItem.telegram??'');
                        } else {
                          Utility.showSnackBar(context, 'invalid link');
                        }

                      },rjItem.telegram != null && rjItem.telegram!.isNotEmpty),

                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: MaterialButton(
                    onPressed: () {
                      Get.back();
                    },
                    shape: const StadiumBorder(),
                    color: AppColors.firstColor,
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  listTile(String s, VoidCallback? callback,bool isNotEmpty) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          if(isNotEmpty) callback!();
        },
        child: ListTile(
          title: Text(
            s,
            style:  TextStyle(color: isNotEmpty?Colors.white:Colors.white.withOpacity(0.4)),
          ),
        ),
      ),
    );
  }
}
