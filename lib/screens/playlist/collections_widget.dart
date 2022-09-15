import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/widgets/menus_title.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

class CollectionsWidget extends GetView<PlayListController> {
  const CollectionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Column(
        children:  [
          const MenusTitle(text: 'by Folder'),
          /*FutureBuilder(
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                try {

                  return const NoDataWidget();
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
            future: ApiService().fetchPodcasts(apiSuffix, query ?? {}),
            // future: ApiService().fetchTrendingPodcasts(),
          ),*/
        ],
      ),
    );
  }
}
