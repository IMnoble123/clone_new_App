import 'package:flutter/material.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/list/rj_list.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

class RjsListVertical extends StatelessWidget {
  final String title;
  final String apiSuffix;
  final Map<String, dynamic>? query;

  const RjsListVertical(
      {Key? key, required this.title, required this.apiSuffix, this.query})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      /*decoration: const BoxDecoration(
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
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 0.0, bottom: 150),
          child: FutureBuilder(
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                try {
                  RjResponse response =
                      RjResponse.fromJson(snapShot.data as dynamic);

                  if (response.status == "Error" || response.rjItems == null) {
                    return const NoDataWidget();
                  }

                  List<RjItem> rjItems = response.rjItems!;

                  return rjItems.isNotEmpty
                      ? RjsList(rjItems: rjItems)
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
            future: ApiService().fetchRjs(apiSuffix, query ?? {}),
            // future: ApiService().fetchTrendingPodcasts(),
          ),
        ),
      ),
    );
  }
}
