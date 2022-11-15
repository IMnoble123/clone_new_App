import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:podcast_app/controllers/playlist_controller.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/collections_data_response.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/playlist/components/collection_item.dart';
import 'package:podcast_app/widgets/no_data_widget.dart';

class CollectionsList extends GetView<PlayListController> {
  const CollectionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if(controller.collections.value.isEmpty){
    //     AlertDialog(
    //     title: const Text('No playlist found'),
    //     actions: [
    //       TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: const Text('Ok'))
    //     ],
    //   );
    //   }
    // });
    /*return SizedBox(
      height: 150,
      child: FutureBuilder(
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return updateCollectionsData(context,snapShot.data);
          } else if (snapShot.hasError) {
            return const NoDataWidget();
          } else {
            return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                ));
          }
        },
        future: ApiService().postData(
            ApiKeys.COLLECTIONS_LIST_SUFFIX, ApiKeys.getMobileUserQuery()),
      ),
    );*/
    print(controller.collections.value.length);
    return Obx(
      () => SizedBox(
          height: controller.collections.value.isNotEmpty
              ? 150
              : MediaQuery.of(context).size.height / 2,
          child: controller.collections.value.isNotEmpty
              ? updateCollectionsDataNew(context, controller.collections.value)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.add,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        'Oops, Your playlist is currently empty.\nFind more of the podcasts \nyou may love from the Home.',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )),
      // : const NoDataWidget()),
    );
  }

  Widget updateCollectionsDataNew(
      BuildContext context, List<CollectionItem> items) {
    try {
      if (items.isNotEmpty) {
        Future.delayed(const Duration(seconds: 1), () {
          controller.selectedCollectionId.value = items[0].folderId!;
          controller.selectedCollectionName.value = items[0].folderName!;

          controller.fetchPodcastByCollectionId();
        });
      } else {
        controller.selectedCollectionId.value = "";
        controller.selectedCollectionName.value = "";
        controller.fetchPodcastByCollectionId();
        return const NoDataWidget();
      }

      return ListView.separated(
        itemBuilder: (c, i) {
          return CollectionUiItem(
              item: items[i],
              playListController: controller,
              deleteCallback: () {
                AppDialogs.simpleSelectionDialog(
                        context,
                        "Confirmation?",
                        "Would you like to remove ${items[i].folderName} collection and its podcasts?",
                        "Remove")
                    .then((value) {
                  if (value == AppConstants.OK) {
                    ApiService()
                        .deleteData(
                            ApiKeys.CREATE_COLLECTION_SUFFIX,
                            ApiKeys.getPodcastsByCollectionIdQuery(
                                items[i].folderId!))
                        .then((value) {
                      //hide success dialog
                      //updateResponse(context, value);

                      controller.fetchCollections();

                      if (controller.selectedCollectionId.value ==
                          items[i].folderId!) {
                        print('entered');
                        controller.selectedCollectionId.value = "";
                        controller.selectedCollectionName.value = "";
                        controller.fetchPodcastByCollectionId();
                      } else if (items.length > 1) {
                        controller.selectedCollectionId.value =
                            items[0].folderId!;
                        controller.selectedCollectionName.value =
                            items[0].folderName!;
                        controller.fetchPodcastByCollectionId();
                      } else {
                        controller.selectedCollectionId.value = "";
                        controller.selectedCollectionName.value = "";
                        controller.fetchPodcastByCollectionId();
                      }
                    });
                  }
                });
              });
        },
        separatorBuilder: (c, i) {
          return const SizedBox(
            width: 5,
          );
        },
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
      );
    } catch (e) {
      return const NoDataWidget();
    }
  }

  Widget updateCollectionsData(
      BuildContext context, List<CollectionItem> items) {
    try {
      if (items.isNotEmpty) {
        Future.delayed(const Duration(seconds: 1), () {
          controller.selectedCollectionId.value = items[0].folderId!;
          controller.selectedCollectionName.value = items[0].folderName!;

          controller.fetchPodcastByCollectionId();
        });
      } else {
        controller.selectedCollectionId.value = "";
        controller.selectedCollectionName.value = "";
        controller.fetchPodcastByCollectionId();
        return const NoDataWidget();
      }

      return SlidableAutoCloseBehavior(
        closeWhenTapped: true,
        closeWhenOpened: true,
        child: ListView.separated(
          itemBuilder: (c, i) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Slidable(
                key: ValueKey(i),
                closeOnScroll: true,
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  openThreshold: 0.1,
                  closeThreshold: 0.4,
                  extentRatio: 0.8,
                  children: [
                    SlidableAction(
                      onPressed: (c) {
                        AppDialogs.simpleSelectionDialog(
                                context,
                                "Confirmation?",
                                "Would you like to remove ${items[i].folderName} collection and its podcasts?",
                                "Remove")
                            .then((value) {
                          if (value == AppConstants.OK) {
                            ApiService()
                                .deleteData(
                                    ApiKeys.CREATE_COLLECTION_SUFFIX,
                                    ApiKeys.getPodcastsByCollectionIdQuery(
                                        items[i].folderId!))
                                .then((value) {
                              //hide success dialog
                              //updateResponse(context, value);

                              controller.fetchCollections();

                              if (controller.selectedCollectionId.value ==
                                  items[i].folderId!) {
                                print('entered');
                                controller.selectedCollectionId.value = "";
                                controller.selectedCollectionName.value = "";
                                controller.fetchPodcastByCollectionId();
                              } else if (items.length > 1) {
                                controller.selectedCollectionId.value =
                                    items[0].folderId!;
                                controller.selectedCollectionName.value =
                                    items[0].folderName!;
                                controller.fetchPodcastByCollectionId();
                              } else {
                                controller.selectedCollectionId.value = "";
                                controller.selectedCollectionName.value = "";
                                controller.fetchPodcastByCollectionId();
                              }
                            });
                          }
                        });
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: 100,
                      //height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    imageUrl: AppConstants.dummyFolderPic,
                                    width: 100,
                                    height: 100,
                                    memCacheWidth: 100,
                                    memCacheHeight: 100,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  )),
                            ],
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              items[i].folderName!,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
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
                          controller.selectedCollectionId.value =
                              items[i].folderId!;
                          controller.selectedCollectionName.value =
                              items[i].folderName!;

                          controller.fetchPodcastByCollectionId();
                        },
                        onLongPress: () {
                          /*
                          AppDialogs.simpleSelectionDialog(
                                  context,
                                  "Confirmation?",
                                  "Would you like to remove ${items[i].folderName} collection and its podcasts?",
                                  "Remove")
                              .then((value) {
                            if (value == AppConstants.OK) {
                              ApiService()
                                  .deleteData(
                                      ApiKeys.CREATE_COLLECTION_SUFFIX,
                                      ApiKeys.getPodcastsByCollectionIdQuery(
                                          items[i].folderId!))
                                  .then((value) {

                                updateResponse(context, value);

                                if(controller.selectedCollectionId.value == items[i].folderId!){
                                  print('entered');
                                  controller.selectedCollectionId.value = "";
                                  controller.selectedCollectionName.value = "";
                                  controller.fetchPodcastByCollectionId();
                                }else if(items.length>1){
                                  controller.selectedCollectionId.value = items[0].folderId!;
                                  controller.selectedCollectionName.value = items[0].folderName!;
                                  controller.fetchPodcastByCollectionId();
                                }else{
                                  controller.selectedCollectionId.value = "";
                                  controller.selectedCollectionName.value = "";
                                  controller.fetchPodcastByCollectionId();
                                }

                              });
                            }
                          });*/
                        },
                      ),
                    )),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (c, i) {
            return const SizedBox(
              width: 2,
            );
          },
          itemCount: items.length,
          scrollDirection: Axis.horizontal,
        ),
      );
    } catch (e) {
      return const NoDataWidget();
    }
  }

  /*Widget updateCollectionsData(BuildContext context, dynamic responseData) {
    try {
      CollectionsDataResponse collectionsDataResponse =
          CollectionsDataResponse.fromJson(responseData);

      if (collectionsDataResponse.status == "Error")
        return const NoDataWidget();

      List<CollectionItem> items = collectionsDataResponse.response!;

      if (items.isEmpty) return const NoDataWidget();

      if (controller.selectedCollectionId.value.isEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          controller.selectedCollectionId.value = items[0].folderId!;
          controller.selectedCollectionName.value = items[0].folderName!;
        });
      }

      return ListView.separated(
        itemBuilder: (c, i) {
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
                              child: CachedNetworkImage(
                                imageUrl: AppConstants.dummyFolderPic,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )),
                        ],
                        alignment: Alignment.center,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          items[i].folderName!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
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
                      controller.selectedCollectionId.value =
                          items[i].folderId!;
                      controller.selectedCollectionName.value =
                          items[i].folderName!;
                    },
                    onLongPress: () {
                      AppDialogs.simpleSelectionDialog(
                              context,
                              "Confirmation?",
                              "Would you like to remove ${items[i].folderName} collection and its podcasts?",
                              "Remove")
                          .then((value) {
                        if (value == AppConstants.OK) {
                          ApiService()
                              .deleteData(
                                  ApiKeys.CREATE_COLLECTION_SUFFIX,
                                  ApiKeys.getPodcastsByCollectionIdQuery(
                                      items[i].folderId!))
                              .then((value) {
                            updateResponse(context, value);
                          });
                        }
                      });
                    },
                  ),
                )),
              ],
            ),
          );
        },
        separatorBuilder: (c, i) {
          return const SizedBox(
            width: 2,
          );
        },
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
      );
    } catch (e) {
      return const NoDataWidget();
    }
  }*/

  void updateResponse(context, response) {
    ResponseData responseData = ResponseData.fromJson(response);

    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      AppDialogs.simpleOkDialog(context, 'Success',
              "Successfully removed the collection from your playlist.")
          .then((value) {
        controller.fetchCollections();
      });
    } else {
      AppDialogs.simpleOkDialog(context, 'Failed',
          responseData.response ?? "unable to process request");
    }
  }
}
