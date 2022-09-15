import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/category_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/header.dart';
import 'package:podcast_app/widgets/menus_title.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

import '../screens/main/main_page.dart';

class Categories extends GetView<MainController> {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          HeaderSection(
            title: 'Browse by Categories',
            callback: () {
              Navigator.of(context).pushNamed(AppRoutes.browseCategories);
            },
          ),
          FutureBuilder(
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                return updateData(snapShot.data);
              } else if (snapShot.hasError) {
                return const Text(
                  'Error',
                  style: TextStyle(color: Colors.white),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
            future: ApiService().fetchCategories(),
          ),
          /*SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                catItem('Comedy'),
                catItem('News'),
                catItem('Culture'),
                catItem('Business'),
                catItem('RJs'),
                catItem('Sports'),
              ],
            ),
          )*/
        ],
      ),
    );
  }

  catItem(BuildContext context, Category category,double cardWidth) {


    return Stack(
      children: [
        SizedBox(
          width: cardWidth,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: Container(
                  width: cardWidth,
                  height: cardWidth,
                  decoration: const BoxDecoration(
                      color: Colors.transparent,
                      // color: AppColors.firstColor.withOpacity(0.25),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: CachedNetworkImage(
                    imageUrl: category.image!.isNotEmpty
                        ? category.image!
                        : AppConstants.dummyPic,
                    /*memCacheWidth: cardWidth.toInt(),
                    memCacheHeight: cardWidth.toInt(),*/
                    fit: BoxFit.cover,
                    /*child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SvgPicture.network(
                       category.image!.isNotEmpty
                          ? category.image!
                          : "http://i.pinimg.com/474x/87/2f/e3/872fe3815376b2cd32106527eac73b73.jpg",width: 30,height: 30,
                    ),*/
                    /*child: CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      width: 55,
                      height: 55,
                      imageUrl: category.image!.isNotEmpty
                          ? category.image!
                          : "http://i.pinimg.com/474x/87/2f/e3/872fe3815376b2cd32106527eac73b73.jpg",
                    ),*/
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Flexible(
                child: Text(
                  category.name ?? "",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              )
            ],
          ),
        ),
        Positioned.fill(
            child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              //AppRoutes.pushScreenByArgs(context, category.name!,category.name!);
              Navigator.of(context).pushNamed(AppRoutes.podcastListCategory,
                  arguments:
                      ScreenArguments(category.name!, category.name!, ''));
            },
          ),
        ))
      ],
    );
  }

  /*catItem(String s) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
                color: AppColors.firstColor.withOpacity(0.25),
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(Radius.circular(10.0))),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: ImageIcon(
                AssetImage('images/search_icon.png'),
                color: Colors.white,
              ),
            ),
          ),
          Text(
            s,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }*/

  Widget updateData(dynamic data) {
    print(data);

    CategoryResponse response = CategoryResponse.fromJson(data);

    if (response.categories == null && response.categories!.isEmpty)
      return const NoDataWidget();

    Future.delayed(const Duration(seconds: 5), () {
      print('old categories called');
      controller.categories.value = response.categories!;
    });

    var cardWidth =
        MediaQuery.of(MainPage.activeContext!).size.width / 2 - 3 * 15;

    return SizedBox(
      height: cardWidth+30,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (c, i) {
            return catItem(c, response.categories![i],cardWidth);
          },
          separatorBuilder: (c, i) {
            return const SizedBox(
              width: 20,
            );
          },
          itemCount: response.categories!.length),
    );
  }
}
