import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:podcast_app/models/response/countries_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';

class AuthController extends GetxController {
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  final passwordController = TextEditingController();

  RxBool showPassWord = true.obs;

  RxBool agreeChecked = false.obs;


  DateTime? selectedDateTime;
  String? selectedDate;

  RxString selectedContryCode = "+91".obs;

  int minimumAge = 13;
  int maximumAge = 100;

  final DateFormat dateFormat = DateFormat('dd MM yyyy');
  String? selectedDob = '';

  RxList<Country> countriesList = <Country>[].obs;

  @override
  void onInit() {
    super.onInit();
   
    isUserLoggedIn();
  }

  togglePasswordVisibility(){
    showPassWord.value = !showPassWord.value;
    update();
  }

  isUserLoggedIn() async {

  }

  login(String email, String password) async {

  }

  createAccount(String email, String password, String name) async {
    try {
      var result = await createAccount(email, password, name);
      print(result);
    } catch (e) {
      print(e);
    }
  }

  RxBool isCountriesLoading = false.obs;

  fetchCountries() async{

    isCountriesLoading.value = true;


    final res = await ApiService().getServerItems(ApiKeys.COUNTRIES_SUFFIX);

    try{

      CountriesData countriesData = CountriesData.fromJson(res);

      if(countriesData.status=="Success"){
        countriesList.value = countriesData.countries!;
      }
      else{
        countriesList.value=[];
      }

    }catch(e){
      print(e);
      countriesList.value=[];
    }

    isCountriesLoading.value = false;

    update();

  }

  @override
  void onClose() {

    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    passwordController.dispose();

    super.onClose();
  }
}
