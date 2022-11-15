import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/dynamic_links_service.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileShareScreen extends StatelessWidget {
  final RjItem rjItem;
  const ProfileShareScreen({Key? key, required this.rjItem}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    // final FlutterShareMe flutterShareMe = FlutterShareMe();

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
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'images/share_circle.png',
                width: 50,
                height: 50,
              ),
              const Text(
                'Share Profile Via',
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListView(
                  primary: false,
                  shrinkWrap: true,
                  itemExtent: 50,
                  children: [
                    listTile('images/copy_link.png', 'Copy Link', () {
                      DynamicLinksService.createRjDynamicLink(
                          rjItem)
                          .then((value) {
                        print('hello....................$value');

                        Clipboard.setData(ClipboardData(text: value));

                        Utility.showSnackBar(context, 'Copied');

                      });

                    }),
                    listTile('images/whats_app.png', 'Whatsapp', () {

                      DynamicLinksService.createRjDynamicLink(
                          rjItem)
                          .then((value) async{

                        print(value);

                        // final url = "https://wa.me/?text=$value";
                        //final url = "https://wa.me/?text=YourTextHere";
                        final url = "https://api.whatsapp.com/send?text=$value";

                        if(await canLaunch(url)){
                          launch(url);
                        }

                        // flutterShareMe.shareToWhatsApp(msg: value);

                      });

                    }),

                    listTile('images/telegram.png', 'Telegram', () {

                      DynamicLinksService.createRjDynamicLink(
                          rjItem)
                          .then((value) async{
                        print(value);
                        final url = "https://telegram.me/share/url?url=$value";
                        if(await canLaunchUrl(Uri.parse(url))){
                          launchUrl(Uri.parse(url));
                        }

                      });

                    }),
                    listTile('images/email.png', 'Email', () {

                      DynamicLinksService.createRjDynamicLink(
                          rjItem)
                          .then((value) async{
                        print(value);
                        Utility.composeEmail(context, '',body: value);

                      });


                    }),
                   /* listTile(
                        'images/messanger.png', 'Facebook messenger', () {

                      DynamicLinksService.createRjDynamicLink(
                          rjItem)
                          .then((value) async{
                        print(value);
                        Utility.composeEmail(context, '',body: value);

                      });

                    }),
                    listTile('images/message_icon.png', 'Message', () {

                    }),*/
                    listTile('images/more_vertical.png', 'More', () {

                      DynamicLinksService.createRjDynamicLink(
                          rjItem)
                          .then((value) async{
                        print(value);
                        Share.share(value);

                      });



                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: MaterialButton(
                  onPressed: () {
                    //Share.share('check out TomTom Podcast app');

                    DynamicLinksService.createRjDynamicLink(
                        rjItem)
                        .then((value) async{
                      print(value);
                      Share.share(value);

                    });

                  },
                  shape: const StadiumBorder(),
                  color: AppColors.firstColor,
                  child: const Text(
                    'More',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  listTile(String path, String title, VoidCallback callback) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: callback,
        child: ListTile(
          leading: ImageIcon(
            AssetImage(path),
            color: AppColors.iconColor,
          ),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
