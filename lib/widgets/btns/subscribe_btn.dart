import 'package:flutter/material.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import 'package:podcast_app/utils/utility.dart';
import '../../extras/app_colors.dart';

class SubScribeButton extends StatefulWidget {
  final RjItem rjItem;

  const SubScribeButton({
    Key? key,
    required this.rjItem,
  }) : super(key: key);

  @override
  State<SubScribeButton> createState() => _SubScribeButtonState();
}

class _SubScribeButtonState extends State<SubScribeButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.rjItem.subscribed!.toString() == "0"
            ? AppColors.firstColor
            : AppColors.inActiveColor,
        shape: const StadiumBorder(
          side: BorderSide(color: AppColors.firstColor),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: widget.rjItem.subscribed!.toString() == "1"
                      ? "Subscribed "
                      : "Subscribe"),
              const WidgetSpan(
                child: Icon(
                  Icons.notifications_none,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      onPressed: () {
        if (CommonNetworkApi().mobileUserId == "-1") {
          Utility.showRegistrationPromotion(context);
          return;
        }
        ApiService()
            .postData(ApiKeys.SUBSCRIBE_SUFFIX,
                ApiKeys.getSubscribedQuery(widget.rjItem.rjUserId!),
                ageNeeded: false
                )
            .then((value) {
          ResponseData responseData = ResponseData.fromJson(value);
          setState(() {
            print(
                'subscribed data= ${responseData.statusDescription} = ..................................... ');
            widget.rjItem.subscribed = responseData.response
                    .toString()
                    .toLowerCase()
                    .contains(('Unsubscribed').toLowerCase())
                ? "0"
                : "1";
          });
          AppDialogs.simpleOkDialog(
              context, 'Success', responseData.response ?? '');
        });
        // }
      },
    );
  }
}
