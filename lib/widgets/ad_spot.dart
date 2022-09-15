import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/ad_controller.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/models/response/ads_response_data.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class AdSpotWidget extends StatelessWidget {
  const AdSpotWidget({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final adsController  = Get.find<AdsController>();

    return FutureBuilder(
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          try {
            AdsResponseData response =
                AdsResponseData.fromJson(snapShot.data as dynamic);

            if (response.status == "Error" || response.response == null) {
              return const NoDataWidget();
            }
            print(snapShot.data);
            return updateServerAds(response.response!,adsController);
          } catch (e) {
            return const NoDataWidget();
          }

          // return updateTilesData(snapShot.data, categoryName!);
        } else if (snapShot.hasError) {
          return const Text(
            'Error',
            style: TextStyle(color: Colors.white),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(
            strokeWidth: 3.0,
          ));
        }
      },
      future: ApiService().getServerItems(ApiKeys.ADS_SUFFIX),
      // future: ApiService().fetchTrendingPodcasts(),
    );
  }

  /*Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
            items: getAdLists(),
            carouselController: _controller,
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (i, s) {
                setState(() {
                  _current = i;
                });
              },
              scrollDirection: Axis.horizontal,
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 10.0,
                height: 10.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == entry.key
                        ? Colors.white
                        : Colors.white.withOpacity(0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );

    */ /*return Column(
      children: [
        const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Discover',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            )),
        const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Discover the Best of podcast for you',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.normal),
              ),
            )),
        SizedBox(
          width: double.infinity,
          height: 200,
          child: PageView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.red),
                );
              }),
        )
      ],
    );*/ /*
  }*/

  Widget updateServerAds(List<AdItem> list, AdsController adsController,) {
    return Column(
      children: [
        CarouselSlider(
            items: getAdLists(list),
            carouselController: adsController.carouselController,
            options: CarouselOptions(
              height: 200,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              onPageChanged: (i, s) {

                adsController.currentPosition.value = i;

              },
              scrollDirection: Axis.horizontal,
            )),
        Obx(
          ()=> Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: list.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => adsController.carouselController.animateToPage(entry.key),
                child: Container(
                  width: 5.0,
                  height: 5.0,
                  margin:
                      const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: adsController.currentPosition.value == entry.key
                          ? Colors.white
                          : Colors.white.withOpacity(0.4)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  getAdLists(List<AdItem> adItems) {
    List<Widget> items = [];

    for (int i = 0; i < adItems.length; i++) {
      items.add(ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(adItems[i].image!))),
          ),
          Positioned.fill(
              child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (adItems[i].linkType!.toLowerCase() == "web") {
                        final url = adItems[i].linkValue;

                        if (url == null || url.isEmpty) return;

                        if (url.contains('http') || url.contains('https')) {
                          launch(url);
                        } else {
                          launch('https://' + url);
                        }
                      } else if (adItems[i].linkType!.toLowerCase() ==
                              "podcast" &&
                          adItems[i].linkValue != null &&
                          adItems[i].linkValue!.isNotEmpty) {

                        playPodcast(adItems[i].linkValue!);

                      }
                    },
                  )))
        ]),
      ));
    }

    return items;
  }

  void playPodcast(String podcastId) async {
    final responseData = await ApiService().postData(
        ApiKeys.PODCAST_BY_ID_SUFFIX,
        ApiKeys.getPodcastsByPodcastIdQuery(podcastId));

    PodcastResponse response =
        PodcastResponse.fromJson(responseData as dynamic);

    if (response.status == "Error" || response.podcasts == null) {
      return;
    }

    List<Podcast> podcasts = response.podcasts!;

    if (podcasts.isNotEmpty) {
      Get.find<MainController>().tomtomPlayer.addAllPodcasts(podcasts, 0);
      Get.find<MainController>().togglePanel();
    }
  }

/*getAdLists() {
    List<Widget> items = [];

    for (int i = 0; i < images.length; i++) {
      items.add(ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(images[i]))),
        ),
      ));
    }

    return items;
  }*/
}
