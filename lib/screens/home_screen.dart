import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podcast_app/controllers/search_controller.dart';
import 'package:podcast_app/models/search_response.dart';
import 'package:podcast_app/network/api_services.dart';
import 'package:podcast_app/screens/audio_recorder.dart';
import 'package:podcast_app/screens/music_player.dart';
import 'package:podcast_app/widgets/card_item.dart';
import 'package:podcast_app/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = Get.find<SearchController>();

  @override
  void initState() {
    super.initState();
    searchController.searchText.value = 'telugu';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children:  [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        )),
                    const SearchBar(),
                  ],
                ),
                Expanded(
                  child: Obx(() => searchController.searchText.isEmpty
                      ? Center(
                          child: Text(
                          'No data found!',
                          style: GoogleFonts.slabo27px(
                              color: Colors.black87, fontSize: 20),
                        ))
                      : FutureBuilder(
                          future: ApiService().fetchSearchResults(
                              prepareQuery(searchController.searchText.value)),
                          builder: (context, snapshot) {
                            // operation for completed state
                            print(snapshot.data);
                            if (snapshot.hasData) {
                              SearchResponse sr = SearchResponse.fromJson(
                                  snapshot.data as Map<String, dynamic>);
                              return sr.results!.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GridView.builder(
                                          itemCount: sr.results!.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 1 / 1,
                                                  mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return CardItem(
                                              imgUrl:
                                                  sr.results![index].thumbnail,
                                              title: sr.results![index]
                                                  .titleOriginal,
                                              tapCallback: () {
                                                FocusScope.of(context)
                                                    .unfocus();
                                                SystemChrome
                                                    .setEnabledSystemUIMode(
                                                        SystemUiMode
                                                            .immersiveSticky);
                                                Get.to(MusicPlayerScreen(
                                                  podItem: sr.results![index],
                                                ));
                                              },
                                            );
                                          }),
                                    )
                                  : Center(
                                      child: Text(
                                        'No data found!',
                                        style: GoogleFonts.slabo27px(
                                            color: Colors.black87,
                                            fontSize: 20),
                                      ),
                                    );
                              /*return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var item = snapshot.data[index];
                              return searchItem(item);
                            })*/
                              ;
                            }

                            // spinner for uncompleted state
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        )),
                )
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 5.0,
          onPressed: () {
            Get.to(const AudioRecorderScreen());
          },
          child: const Icon(
            Icons.mic,
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget searchItem(item) {
    return ListTile();
  }

  Map<String, dynamic> prepareQuery(String searchText) {
    final query = {'q': searchText, 'language': 'Telugu'};

    return query;
  }
}
