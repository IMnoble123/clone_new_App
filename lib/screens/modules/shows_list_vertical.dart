import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/main_controller.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/routes.dart';
import 'package:podcast_app/extras/screen_args.dart';
import 'package:podcast_app/models/response/shows_response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';


class ShowsListVertical extends GetView<MainController> {
  final String title;
  final String apiSuffix;
  final Map<String, dynamic>? query;

  const ShowsListVertical(
      {Key? key, required this.title, required this.apiSuffix, this.query})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          title: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),

          /*Obx(
            ()=> Text(
              '$title (${controller.showsCount.value})',
              style: const TextStyle(color: Colors.white),
            ),
          ),*/
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder(
                  builder: (context, snapShot) {
                    if (snapShot.hasData) {
                      try {
                        ShowsResponseData response = ShowsResponseData.fromJson(
                            snapShot.data as dynamic);

                        if (response.status == "Error" ||
                            response.showsList == null) {
                          return const NoDataWidget();
                        }

                        return updateShowsData(response.showsList!);
                      } catch (e) {
                        return const NoDataWidget();
                      }

                      // return updateTilesData(snapShot.data, categoryName!);
                    } else if (snapShot.hasError) {
                      return const Text(
                        'No Data',
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      return const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 3.0,
                      ));
                    }
                  },
                  future: ApiService().postData(apiSuffix, query ?? {}),
                ),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget updateShowsData(List<ShowItem> shows) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.showsCount.value = shows.length;
    });
    


    return ListView.separated(
        itemBuilder: (c, i) {
          return showItem(shows[i], i, c);

        },
        separatorBuilder: (c, i) {
          return const Divider();
        },
        shrinkWrap: true,
        primary: false,
        itemCount: shows.length);
  }

  Container showItem(ShowItem showItem, int i, BuildContext c) {
    return Container(
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(8.0))),
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Stack(alignment: Alignment.center, children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: CachedNetworkImage(
                          imageUrl: showItem.showsImage!.isNotEmpty &&
                              !showItem.showsImage!.contains(".jfif")
                              ? showItem.showsImage!
                              : AppConstants.dummyPic,
                          width: 75,
                          height: 75,memCacheWidth: 75,memCacheHeight: 75,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )),
                    /*CircleAvatar(
                      backgroundColor: Colors.red.withOpacity(0.5),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 30,
                      ),
                    )*/
                  ]),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          showItem.showsName ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        /*Text(
                          '${showItem.totalPodcast ?? '0'} episodes',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.disableColor,
                          ),
                        )*/


                      ],
                    ),
                  )),
                  /*IconButton(
                      splashColor: AppColors.firstColor.withOpacity(0.4),
                      onPressed: () {

                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ))*/
                ],
              ),
              Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        //Get.find<MainController>().togglePanel();

                        FocusScope.of(c).unfocus();

                        // final args = ScreenArguments('${showItem.showsName!} (${showItem.totalPodcast})' , ApiKeys.PODCASTS_BY_SHOW_SUFFIX,  ApiKeys.getPodcastsByShowIdQuery(showItem.showsId!));
                        final args = ScreenArguments(showItem.showsName! , ApiKeys.PODCASTS_BY_SHOW_SUFFIX,  ApiKeys.getPodcastsByShowIdQuery(showItem.showsId!));
                        Navigator.pushNamed(c, AppRoutes.podcastListScreenVertical,arguments: args);


                      },
                    ),
                  ))
            ],
          ),
        );
  }
}
