import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/models/response/rj_response.dart';

class RjController extends GetxController {

   final Rx<RjItem> rjItem = RjItem().obs;

  void updateRjItem(RjItem item) {
    rjItem.value = item;
    update();
  }

}
