
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController{

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool showPassWord = true.obs;
  RxBool showConfirmPassWord = true.obs;



}