import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:podcast_app/controllers/search_controller.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final searchController = Get.find<SearchController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 50,
        child: Obx(
          ()=> TextField(

            controller: searchController.stfController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),

              suffixIcon: searchController.searchText.isEmpty
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ))
                  : IconButton(
                      onPressed: () {
                        searchController.clearSearch();
                        FocusScope.of(context).unfocus();
                        //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
              fillColor: Colors.black,
              filled: true,
              labelStyle: GoogleFonts.slabo27px(color: Colors.white54),
              hintStyle: GoogleFonts.slabo27px(color: Colors.white54),
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              hintText: 'Search by Topic or Host',
            ),
            style: GoogleFonts.slabo27px(color: Colors.white),
            onEditingComplete: (){
              print('done click');
              FocusScope.of(context).unfocus();
              //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

            },
          ),
        ),
      ),
    ));
  }

  @override
  void initState() {
    super.initState();
  }
}
