import 'package:flutter/material.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'api_services.dart';

class CommonNetworkApi {
  static final CommonNetworkApi _apiService = CommonNetworkApi.internal();

  CommonNetworkApi.internal();

  factory CommonNetworkApi() {
    return _apiService;
  }

  String mobileUserId = "";
  String mobileUserName = "";

  Future<bool> sendOtp(BuildContext context, String phoneNumber,
      {bool isDialogRequired = true}) async {
    final response = await ApiService()
        .postData(ApiKeys.SEND_OTP_SUFFIX, ApiKeys.getMobileQuery(phoneNumber));

    try {
      // ResponseData responseData = ResponseData.fromJson(response);
      ResponseData responseData = ResponseData.fromJson(response);

      if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
        if (isDialogRequired) {
          // ignore: use_build_context_synchronously
          AppDialogs.simpleOkDialog(
              context, 'Success', responseData.response ?? '');
        }
        return true;
      } else {
        if (isDialogRequired) {
          // ignore: use_build_context_synchronously
          AppDialogs.simpleOkDialog(context, 'Failed',
              responseData.response ?? "unable to process request");
        }
        return false;
      }
    } catch (e) {
      if (isDialogRequired) {
        // ignore: use_build_context_synchronously
        AppDialogs.simpleOkDialog(
            context, 'Failed', "unable to process request");
      }
      return false;
    }
  }

  Future<bool> sendNewOtp(BuildContext context, String phoneNumber,
      {bool isDialogRequired = true}) async {
    final response = await ApiService()
        .postData(ApiKeys.SEND_NEW_OTP_SUFFIX, ApiKeys.getMobileQuery(phoneNumber));

    try {
      // ResponseData responseData = ResponseData.fromJson(response);
      ResponseData responseData = ResponseData.fromJson(response);

      if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
        if (isDialogRequired) {
          // ignore: use_build_context_synchronously
          AppDialogs.simpleOkDialog(
              context, 'Success', responseData.response ?? '');
        }
        return true;
      } else {
        if (isDialogRequired) {
          // ignore: use_build_context_synchronously
          AppDialogs.simpleOkDialog(context, 'Failed',
              responseData.response ?? "unable to process request");
        }
        return false;
      }
    } catch (e) {
      if (isDialogRequired) {
        // ignore: use_build_context_synchronously
        AppDialogs.simpleOkDialog(
            context, 'Failed', "unable to process request");
      }
      return false;
    }
  }

  void postViewed(String podcastId) async {
    Map<String, String> query = {
      "podcast_id": podcastId,
      "mob_user_id": mobileUserId
    };

    await ApiService().postPodcastView(query);
  }
}
