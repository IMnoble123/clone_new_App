import 'package:flutter/material.dart';
import 'package:podcast_app/extras/routes.dart';

import 'menus_title.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final double? fontSize;
  final VoidCallback? callback;

  const HeaderSection({Key? key, required this.title, this.callback, this.fontSize=20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: MenusTitle(
          text: title,size: fontSize!,
        )),
        MaterialButton(
          onPressed: callback!,
         /* onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.browseCategories);
            // Navigator.pushNamed(context, 'Category');
          },*/
          minWidth: 50,
          height: 30,
          child: const Text(
            'See all',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          shape: const RoundedRectangleBorder(
              side: BorderSide(
                  width: 1.0, color: Color.fromARGB(255, 186, 16, 19)),
              borderRadius: BorderRadius.all(Radius.circular(50))),
        )
        /*OutlinedButton(
                onPressed: () {},
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(
                          color: Colors.white,
                          width: 2.0,style: BorderStyle.solid))),
                ),
                child: const Text("Button text"),
              )*/
        /*SizedBox(
                width: 60,
                height: 25,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(color: Color.fromARGB(255, 186, 16, 19),width: 1.0)
                  ),
                  child: const Text('See all',style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,),
                ),
              )*/
        /*MaterialButton(
                onPressed: () {},
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 186, 16, 19), width: 1.0),
                ),
                color: Colors.transparent,child: Text('See all',style: TextStyle(color: Colors.white,fontSize: 12),),
              )*/
      ],
    );
  }
}
