import 'package:flutter/material.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/models/response/rj_response.dart';
import 'package:podcast_app/network/api_services.dart';

class RjsListView extends StatelessWidget {
  final String? categoryName;
  final Function(RjItem)? callback;
  final Future<dynamic>? apiCall;

  const RjsListView({Key? key, this.categoryName, this.callback, this.apiCall})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: FutureBuilder(
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return updateTilesData(snapShot.data, categoryName!);
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
        future: apiCall,
        // future: ApiService().fetchTrendingPodcasts(),
      ),
    );
  }

  Widget updateTilesData(dynamic data, String catName) {
    print(data);

    RjResponse response = RjResponse.fromJson(data);

    if (response.status == "Error") {
      return Container(
        alignment: Alignment.center,
        child: const Text(
          'No Data',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    List<RjItem> rjItems = response.rjItems!;
    return ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                SizedBox(
                  width: 100,
                  //height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                rjItems[index].profileImage!.isNotEmpty
                                    ? rjItems[index].profileImage!
                                    : AppConstants.dummyPic,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,cacheWidth: 100,cacheHeight: 100,
                              )),
                        ],
                        alignment: Alignment.center,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          rjItems[index].rjName!,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          rjItems[index].podcasterType!,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                    child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      callback!(rjItems[index]);
                    },
                  ),
                )),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: 10,
          );
        },
        itemCount: rjItems.length);
  }
}
