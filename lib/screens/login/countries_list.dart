import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/countries_controller.dart';
import '../../extras/app_colors.dart';
import '../../widgets/bg/gradient_bg.dart';
import '../../widgets/bg/tomtom_title.dart';

class CountriesList extends GetView<CountriesController> {
  const CountriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            const LinearGradientBg(),
            Column(
              children: [
                const TomTomTitle(
                  title: 'Choose your country',
                  hideTitle: true,
                  width: 125,
                  height: 125,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 20.0),
                            child: TextField(
                              controller: controller.stfController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 15.0),
                                fillColor: Colors.white,
                                suffixIcon: Transform.translate(
                                  offset: const Offset(3, 0),
                                  child: Obx(
                                    () => controller.searchText.value.isEmpty
                                        ? const Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: CircleAvatar(
                                              backgroundColor: Color.fromARGB(
                                                  255, 186, 16, 19),
                                              child: ImageIcon(
                                                AssetImage(
                                                    'images/search_icon.png'),
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              controller.clearSearch();
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: AppColors.firstColor,
                                            ),
                                          ),
                                  ),
                                ),
                                filled: true,
                                labelStyle:
                                    const TextStyle(color: Colors.black87),
                                hintStyle:
                                    const TextStyle(color: Colors.black87),
                                focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                hintText: 'Search by country name',
                              ),
                              style: const TextStyle(color: Colors.black),
                              onEditingComplete: () {
                                print('done click');
                                FocusScope.of(context).unfocus();
                                /*SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.immersiveSticky);*/
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Obx(
                          () => Expanded(
                              child: controller.countriesList.isEmpty
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : controller.filteredCountriesList.isEmpty
                                      ? const Center(
                                          child: Text(
                                          'No counties found',
                                          style: TextStyle(color: Colors.white),
                                        ))
                                      : MediaQuery.removePadding(
                                          removeTop: true,
                                          context: context,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: RawScrollbar(
                                              thumbVisibility: true,
                                              thumbColor: AppColors.firstColor,
                                              radius: const Radius.circular(20),
                                              thickness: 2,
                                              child: ListView.builder(
                                                itemExtent: 50,
                                                itemBuilder: (c, index) {
                                                  return ListTile(

                                                    title: Text(
                                                      ' ${controller.filteredCountriesList[index].name}',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    trailing: Text(
                                                      '${controller.filteredCountriesList[index].dialcode}',
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onTap: () {
                                                      Navigator.of(context).pop(
                                                          controller
                                                              .filteredCountriesList[
                                                                  index]
                                                              .dialcode);
                                                    },
                                                  );
                                                },
                                                itemCount: controller
                                                    .filteredCountriesList.length,
                                              ),
                                            ),
                                          ),
                                        )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
