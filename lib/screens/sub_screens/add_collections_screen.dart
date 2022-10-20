import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/extras/app_colors.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/extras/keys.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/utils/utility.dart';
import 'package:podcast_app/widgets/btns/wrap_text_btn.dart';

class AddPlayListCollectionScreen extends GetView<PlayListController> {
  final String podcastId;

  const AddPlayListCollectionScreen(this.podcastId, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchCollections();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        key: AppKeys.collectionsScaffoldState,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                    size: 30,
                  )),
            ),
          ],
        ),
        body: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                'Collections',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                  width: 150,
                  child: Divider(
                    color: AppColors.disableColor,
                  )),
              listTile('Add to collections ', () {
                _displayTextInputDialog(context);

                /* showGeneralDialog(
                    context: context,
                    pageBuilder: (context, animation, secondAnimation) {
                      return const CreateCollectionDialog();
                    });*/

                //showDialog(context: context, builder: (BuildContext context) => errorDialog);
              }, addTrail: true),
              Expanded(
                child: Stack(
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: GetBuilder<PlayListController>(
                            builder: (plc) => ListView.builder(
                              itemBuilder: (c, i) {
                                return listTile(
                                    plc.collections.value[i].folderName!, () {
                                  addToCollection(context,
                                      plc.collections.value[i].folderId!);
                                });
                              },
                              controller: controller.scrollController,
                              primary: false,
                              shrinkWrap: true,
                              itemExtent: 50,
                              itemCount: plc.collections.value.length,
                            )),
                        /*child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        itemExtent: 50,
                        children: [
                          for( var collection in controller.collections.value )
                            listTile(collection.folderName!, () { })

                        ],
                      ),*/
                      ),
                    ),
                    Obx(() => controller.showProgress.value
                        ? const Center(
                          child: SizedBox(
                          width: 30, height: 30, child: CircularProgressIndicator()),
                        )
                        : const SizedBox.shrink()),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: MaterialButton(
                  onPressed: () {
                    Get.back();
                  },
                  shape: const StadiumBorder(),
                  color: AppColors.firstColor,
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  listTile(String title, VoidCallback callback, {addTrail = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: callback,
        child: ListTile(
          trailing: addTrail
              ? const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    '+',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              : null,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: const Text('New collection'),
            content: TextField(
              controller: controller.inputController,
              key: AppKeys.collectionTfKey,
              decoration:
                  const InputDecoration(hintText: "Enter collection name"),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WrapTextButton(
                  title: 'Cancel',
                  callback: () {
                    controller.inputController.clear();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  textColor: AppColors.firstColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: WrapTextButton(
                  title: 'Create',
                  callback: () {
                    if (controller.inputController.text.isNotEmpty) {
                      Navigator.of(context, rootNavigator: true).pop();

                      controller.createCollection(
                          context, controller.inputController.text);
                    }
                  },
                  textColor: AppColors.firstColor,
                ),
              ),
            ],
          );
        });
  }

  void addToCollection(BuildContext context, String folderId) async {
    final response = await ApiService().postData(
        ApiKeys.ADD_PODCAST_TO_COLLECTION_SUFFIX,
        ApiKeys.getAddPodcastToCollectionQuery(
            List.filled(1, podcastId), folderId),ageNeeded: false);
    // Get.find<MainController>().currentPodcast!.podcastId!, folderId));

    ResponseData responseData = ResponseData.fromJson(response);

    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      Utility.showSnackBar(context, 'Added');
    } else {
      Utility.showSnackBar(context, responseData.response ?? "Failed");
    }

    Get.back();
  }
}

Dialog errorDialog = Dialog(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  //this right here
  child: SizedBox(
    height: 300.0,
    width: 300.0,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Cool',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextField(
          controller: Get.find<PlayListController>().inputController,
          key: AppKeys.collectionTfKey,
          decoration: const InputDecoration(hintText: "Enter collection name"),
        ),
        const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Awesome',
            style: TextStyle(color: Colors.red),
          ),
        ),
        const Padding(padding: EdgeInsets.only(top: 50.0)),
        TextButton(
            onPressed: () {
              //Navigator.pop(context);
            },
            child: const Text(
              'Got It!',
              style: TextStyle(color: Colors.purple, fontSize: 18.0),
            ))
      ],
    ),
  ),
);
