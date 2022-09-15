import 'package:flutter/material.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:url_launcher/url_launcher.dart';

class TomTomScreen extends StatelessWidget {
  const TomTomScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover)),
      child: SingleChildScrollView(
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset('images/ob_title.png',width: 150,height: 150,),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  iconItem('images/fb.png',() {
                    Utility.openUrls(context, AppConstants.FB_PAGE);
                  }),

                  iconItem('images/instagram.png',(){
                    Utility.openUrls(context, AppConstants.IG_PAGE);
                  }),
                  iconItem('images/twitter.png',(){
                    Utility.openUrls(context, AppConstants.TW_PAGE);
                  }),
                  iconItem('images/email.png',(){

                    Utility.composeEmail(context, AppConstants.EMAIL_TTP);

                  }),
                  iconItem('images/telegram.png',(){
                    Utility.openUrls(context, AppConstants.TG_PAGE);
                  }),
                ],
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: 10,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1 / 1,
                    crossAxisCount: 2,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5),
                itemBuilder: (context, index) {
                  return Container(

                    decoration: BoxDecoration(
                      color: AppColors.firstColor,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  );
                },
                shrinkWrap: true,
                primary: false,
              ),
            ),*/
            const SizedBox(
              height: 150,
            )
          ],
        ),
      ),
    );
  }

  iconItem(String s,VoidCallback callback) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: callback,
          child: ImageIcon(
            AssetImage(
              s,
            ),
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }


}
