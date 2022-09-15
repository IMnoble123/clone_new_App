import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:podcast_app/models/response/countries_data.dart';
import 'package:podcast_app/network/api_services.dart';

import '../network/api_keys.dart';

class CountriesController extends GetxController {
  final stfController = TextEditingController();

  RxString searchText = ''.obs;

  RxList<Country> countriesList = <Country>[].obs;
  RxList<Country> filteredCountriesList = <Country>[].obs;

  @override
  void onInit() {
    super.onInit();

    stfController.addListener(() {
      searchText.value = stfController.text;

      filteredCountriesList.value = countriesList
          .where((element) => element.name!.toLowerCase().contains(searchText.value.toLowerCase()))
          .toList();
    });
  }

  RxBool isCountriesLoading = false.obs;

  fetchCountries() async {

    filteredCountriesList.value = countriesList.value = [];

    isCountriesLoading.value = true;


    final res = await ApiService().getServerItems(ApiKeys.COUNTRIES_SUFFIX);

    try {
      CountriesData countriesData = CountriesData.fromJson(res);

      if (countriesData.status == "Success") {
        filteredCountriesList.value =
            countriesList.value = countriesData.countries!;
      } else {
        filteredCountriesList.value = countriesList.value = [];
      }
    } catch (e) {
      print(e);
      filteredCountriesList.value = countriesList.value = [];
    }

    isCountriesLoading.value = false;

    update();
  }

  void clearSearch() {
    stfController.text = '';
    update();
  }

  @override
  onClose() {
    stfController.dispose();
    super.onClose();
  }


}
