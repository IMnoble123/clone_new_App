import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/db/db.dart';
import 'package:podcast_app/db/db_podcast.dart';
import 'package:podcast_app/extras/app_dialogs.dart';
import 'package:podcast_app/extras/constants.dart';
import 'package:podcast_app/models/response/collections_data_response.dart';
import 'package:podcast_app/models/response/podcast_response.dart';
import 'package:podcast_app/models/response/response_data.dart';
import 'package:podcast_app/models/response/subscibed_response_data.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';

class PlayListController extends GetxController {
  final inputController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  RxInt chipSelectedIndex = 0.obs;
  RxString selectedCollectionId = "".obs;
  RxString selectedCollectionName = "".obs;

  RxString selectedRjId = "".obs;

  RxList<CollectionItem> collections = <CollectionItem>[].obs;
  RxList<Podcast> podcasts = <Podcast>[].obs;

  RxList<RjList> mainRjList = <RjList>[].obs;
  RxList<Podcast> mainPodcasts = <Podcast>[].obs;
  RxList<Podcast> showingPodcasts = <Podcast>[].obs;
  RxList<DpPodcast> dpPodcasts = <DpPodcast>[].obs;

  RxList<Podcast> favList = <Podcast>[].obs;
  /*RxList<Podcast> listenLaterList = <Podcast>[].obs;
  RxList<Podcast> historyList = <Podcast>[].obs;*/


  RxBool showProgress = false.obs;

  @override
  void onInit() {
    super.onInit();

    fetchCollections();
  }

  updateChipSelectedIndex(int i) {
    chipSelectedIndex.value = i;
    update();
  }

  void fetchDownloads() async {
    try {
      dpPodcasts.value = await TomTomDb().dpPodcasts();

      print(dpPodcasts.value.length);
    } catch (e) {
      dpPodcasts.value = [];
    }
  }

  void fetchFavourites(String apiSuffix, Map<String, dynamic> query) async {

    final responseData = await ApiService().postData(apiSuffix, query,ageNeeded: false);

    try {
      PodcastResponse response =
          PodcastResponse.fromJson(responseData as Map<String, dynamic>);

      print(response);

      if (response.status == "Error" || response.podcasts == null) {
        favList.value = [];
        return;
      }

      print(response.podcasts!);

      favList.value = response.podcasts!;

    } catch (e) {
      favList.value = [];
    }

    favList.refresh();
  }

  /*void fetchListenLater(String apiSuffix, Map<String, dynamic>? query) async {
    final responseData = ApiService().fetchRjs(apiSuffix, query ?? {});

    try {
      PodcastResponse response =
          PodcastResponse.fromJson(responseData as dynamic);
      listenLaterList.value = response.podcasts!;
    } catch (e) {
      listenLaterList.value = [];
    }
  }

  void fetchHistory(String apiSuffix, Map<String, dynamic>? query) async {
    final responseData = ApiService().fetchRjs(apiSuffix, query ?? {});

    try {
      PodcastResponse response =
          PodcastResponse.fromJson(responseData as dynamic);
      historyList.value = response.podcasts!;
    } catch (e) {
      historyList.value = [];
    }
  }*/

  void fetchCollections() async {

    showProgress.value = true;

    try {
      final response = await ApiService().postData(
          ApiKeys.COLLECTIONS_LIST_SUFFIX, ApiKeys.getMobileUserQuery());

      CollectionsDataResponse responseData =
          CollectionsDataResponse.fromJson(response);
      if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
        // inputController.clear();

        collections.value = responseData.response!;
        update();

        _scrollDown();

        print('added new collection ${responseData.status}');
      } else {
        /*AppDialogs.simpleOkDialog(context, 'Failed',
           "unable to process request");*/

      }
    } catch (e) {
      log(e.toString());
    }

    showProgress.value = false;

  }

  void fetchPodcastByCollectionId() async {
    if (selectedCollectionId.isEmpty || selectedCollectionName.isEmpty) {
      podcasts.value = [];
      return;
    }

    final responseData = await ApiService().postData(
      ApiKeys.PODCASTS_LIST_BY_COLLECTION_SUFFIX,
      ApiKeys.getPodcastsByCollectionIdQuery(selectedCollectionId.value),ageNeeded: false
    );

    try {
      PodcastResponse response = PodcastResponse.fromJson(responseData);
      podcasts.value.clear();
      if (response.status!.toUpperCase() == AppConstants.SUCCESS) {
        // inputController.clear();
        podcasts.value = response.podcasts!;
        print('added new collection ${response.status}');
      } else {
        /*AppDialogs.simpleOkDialog(context, 'Failed',
           "unable to process request");*/
        podcasts.value = [];
      }
    } catch (e) {
      podcasts.value = [];
    }
  }

  void _scrollDown() {
    if (collections.value.isNotEmpty && scrollController.hasClients) {
      Future.delayed(const Duration(seconds: 1), () {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      });
    }
  }

  void createCollection(BuildContext context, String text) async {

    showProgress.value = true;

    final response = await ApiService().postData(
        ApiKeys.CREATE_COLLECTION_SUFFIX, ApiKeys.createCollectionQuery(text),ageNeeded: false);

    ResponseData responseData = ResponseData.fromJson(response);

    inputController.clear();
    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      fetchCollections();

      print('added new collection ${responseData.status}');
    } else {
      AppDialogs.simpleOkDialog(context, 'Failed',
          responseData.response ?? "unable to process request");
    }


    showProgress.value = false;

  }

  /*void deleteCollection(BuildContext context, String collectionId) async {
    final response = await ApiService().deleteData(
        ApiKeys.CREATE_COLLECTION_SUFFIX,
        ApiKeys.deleteCollectionQuery(collectionId));

    ResponseData responseData = ResponseData.fromJson(response);



    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      print('added new collection ${responseData.status}');
    } else {
      AppDialogs.simpleOkDialog(context, 'Failed',
          responseData.response ?? "unable to process request");
    }
  }*/

  void deletePodcastItem(context, podcastId) async {
    final response = await ApiService().deleteData(
        ApiKeys.DELETE_PODCAST_FROM_COLLECTION_SUFFIX,
        ApiKeys.deletePodcastQuery(podcastId));

    ResponseData responseData = ResponseData.fromJson(response);

    inputController.clear();

    if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
      print('print...................................................$responseData');
    } else {
      AppDialogs.simpleOkDialog(context, 'Failed',
          responseData.response ?? "unable to process request");
    }
  }

  void fetchSubscribedList() async {
    try {
      final response = await ApiService().postData(
          ApiKeys.SUBSCRIBED_LIST_SUFFIX, ApiKeys.getMobileUserQuery(),ageNeeded: false);

      SubscibedResponseData responseData =
          SubscibedResponseData.fromJson(response);

      if (responseData.status!.toUpperCase() == AppConstants.SUCCESS) {
        mainRjList.value = responseData.response!.rjList!;
        mainPodcasts.value =
            responseData.response!.podcastList!;
        showingPodcasts.value = mainPodcasts.value;

        print('------${mainRjList.value.length}');
      } else {
        mainRjList.value = [];
        mainPodcasts.value = [];
        showingPodcasts.value = [];
      }
    } catch (e) {
      print(e.toString());
      mainRjList.value = [];
      mainPodcasts.value = [];
      showingPodcasts.value = [];
    }
  }

  void filterPodcastsByRjId() {
    if (selectedRjId.value.isNotEmpty && mainPodcasts.value.isNotEmpty) {
      showingPodcasts.value = mainPodcasts.value
          .where((element) => element.userId == selectedRjId.value)
          .toList();
    } else {
      showingPodcasts.value = [];
    }
  }
}
