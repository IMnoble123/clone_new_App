import 'dart:io';

import 'package:flutter/material.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';
import 'package:podcast_app/widgets/list/podcast_list.dart';

class PodcastListVertical extends StatelessWidget {
  final String title;
  final String apiSuffix;
  final Map<String, dynamic>? query;
  final String? filter;

  const PodcastListVertical(
      {Key? key,
      required this.title,
      required this.apiSuffix,
      this.query,
      this.filter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     /* decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: AssetImage('images/ob_bg.png'),
              fit: BoxFit.cover,
              opacity: 0.6)),*/
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FutureBuilder(
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    try {
                      PodcastResponse response =
                          PodcastResponse.fromJson(snapShot.data as dynamic);

                      if (response.status == "Error" ||
                          response.podcasts == null) {
                        return const NoDataWidget();
                      }

                      List<Podcast> podcasts;
                      if (filter != null && filter!.isNotEmpty) {
                        podcasts = response.podcasts!
                            .where((element) =>
                                element.category!.contains(filter!))
                            .toList();
                      } else {
                        podcasts = response.podcasts!;
                      }

                      return podcasts.isNotEmpty
                          ? Expanded(
                            child: PodcastList(
                                podcasts: podcasts,
                                shrinkWrap: false,
                              ),
                          )
                          : const NoDataWidget();
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
                // future: ApiService().fetchRjs(apiSuffix, query ?? {}),
                // future: ApiService().fetchTrendingPodcasts(),
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
