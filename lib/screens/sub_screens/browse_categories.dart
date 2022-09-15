import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/item.dart';
import 'package:podcast_app/models/response/category_response.dart';
import 'package:podcast_app/network/api_services.dart';

import '../main/main_page.dart';

class BrowseCategoriesScreen extends StatelessWidget {
  const BrowseCategoriesScreen({Key? key}) : super(key: key);

  static final List<Item> _items = List.generate(
      15,
      (index) => Item.fromJson({
            "id": 1,
            "imgUrl":
                "https://is4-ssl.mzstatic.com/image/thumb/Purple124/v4/6a/e4/59/6ae45956-8b3d-0ff2-81f8-587c7c65b515/source/512x512bb.jpg",
            "title": "Title",
            "subtitle": "SubTitle"
          }));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      /*decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover)),*/
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          gradient: LinearGradient(
              colors: [Color.fromARGB(255, 54, 0, 0), Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.0, 0.5])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Browse by Categories',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
      /*child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              const Text(
                'Browse by Categories',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )
            ],
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
          //const SizedBox(height: 150,),
        ],
      ),*/
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'), fit: BoxFit.cover)),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                     Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              const Text(
                'Browse by Categories',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          Expanded(
            child: GridView.builder(
                itemCount: _items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 3 / 3.75 ,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                  mainAxisSpacing: 5
                    ),
                itemBuilder: (context, index) {
                  return ItemWidget(_items[index]);
                }),
          ),
        ],
      ),
    );
  }*/

  Widget ItemWidget(BuildContext context, Category category, double cardWidth) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    clipBehavior: Clip.hardEdge,
                    child: Container(
                        //color: AppColors.firstColor.withOpacity(0.4),
                        width: double.infinity,
                        //padding: const EdgeInsets.all(16.0),
                        child: /*SvgPicture.network(
                        category.image!.isNotEmpty
                            ? category.image!
                            : "http://i.pinimg.com/474x/87/2f/e3/872fe3815376b2cd32106527eac73b73.jpg",fit: BoxFit.cover,
                      ),*/
                            CachedNetworkImage(
                          imageUrl: category.image!.isNotEmpty
                              ? category.image!
                              : AppConstants.dummyPic,
                          fit: BoxFit.cover,
                          width: cardWidth,
                          height: cardWidth,
                          memCacheWidth: cardWidth.toInt() * 2,
                          memCacheHeight: cardWidth.toInt() * 2,
                        )) /*child: Image.network(
                      category.image!.isNotEmpty
                          ? category.image!
                          : "http://i.pinimg.com/474x/87/2f/e3/872fe3815376b2cd32106527eac73b73.jpg",
                    )*/
                    ),
              ),
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category.name ?? '',
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              /*Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  category.podcastsCount!=null? '${category.podcastsCount} Topics':"0 Topics",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.75), fontSize: 14),
                ),
              ),*/
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          Positioned.fill(
              child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // AppRoutes.pushScreenByArgs(context, category.name!,category.name!);
                Navigator.of(context).pushNamed(AppRoutes.podcastListCategory,
                    arguments:
                        ScreenArguments(category.name!, category.name!, ''));
              },
            ),
          ))
        ],
      ),
    );
  }

  Widget updateData(dynamic data) {
    CategoryResponse response = CategoryResponse.fromJson(data);

    var cardWidth =
        MediaQuery.of(MainPage.activeContext!).size.width / 2;

    return Expanded(
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: response.categories!.length,
            padding: const EdgeInsets.only(bottom: 200),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 3 / 3.5, //3/3.75
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return ItemWidget(
                  context, response.categories![index], cardWidth);
            }));
  }
}
