import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:podcast_app/models/response/report_items_response.dart';
import 'package:podcast_app/network/api_keys.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/network/common_network_calls.dart';
import '../../extras/app_colors.dart';

class ReportScreen extends StatefulWidget {
  final String id;
  final bool isPodcast;
  const ReportScreen({Key? key, required this.id, required this.isPodcast})
      : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<ReportItem> reportItems = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    ApiService().fetchItems(ApiKeys.COMMENTS_REPORT).then((value) {
      print('value.......................$value');
      ReportItemsResponse response = reportResponseFromJson(jsonEncode(value));

      if (response.status == "Success") {
        // print('responce.............$reportItems');
        reportItems.clear();
        reportItems.addAll(response.reportItems!.reversed);
        print('report...................$reportItems');

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
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
      body: Theme(
        data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.white, disabledColor: Colors.grey),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Text(
              'Report on ${widget.isPodcast ? "Podcast" : "Comment"}',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Divider(
                color: AppColors.disableColor,
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemExtent: 50,
            //     reverse: true,
            //     itemBuilder: (context, index) {
            //       return rbItem(reportItems[index]);
            //     },
            //     itemCount: reportItems.length,
            //   ),
            // ),

            Expanded(
                child: ListView.builder(
                    itemCount: reportItems.length,
                    itemBuilder: ((context, index) {
                      return rbItem(reportItems[index]);
                    }))),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: MaterialButton(
                onPressed: () {
                  //Get.back();
                  postReport(groupValue, widget.id);
                },
                shape: const StadiumBorder(),
                color: AppColors.firstColor,
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  String groupValue = '';

  Widget rbItem(ReportItem reportItem) {
    return RadioListTile<String>(
        value: reportItem.id!,
        title: Text(reportItem.name!, style: const TextStyle(color: Colors.white,fontSize: 13),),
        groupValue: groupValue,
        onChanged: (value) {
          groupValue = value!;
          setState(() {});
        });

    // return ListTile
    //   onTap: () => setState(() => groupValue = int.parse(reportItem.id!)),
    //   leading: Radio<int>(
    //     value: int.parse(reportItem.id!),
    //     toggleable: true,
    //     groupValue: groupValue,
    //     onChanged: (value) {
    //       setState(() {
    //         groupValue = value!;
    //       });
    //     },
    //   ),
    //   title: Text(
    //     '${reportItem.name}',
    //     style: const TextStyle(color: Colors.white, fontSize: 14),
    //   ),
    // );
  }

  void postReport(String groupValue, String id) {
    Map<String, dynamic> json = {
      "type": widget.isPodcast ? "podcast" : "comment",
      "type_id": id,
      "reported_master_id": groupValue,
      "reported_mob_user_id": CommonNetworkApi().mobileUserId,
      "description": ""
    };

    ApiService().postData(ApiKeys.COMMENT_REPORTED, json).then((value) {
      Get.back();
    });
  }
}
