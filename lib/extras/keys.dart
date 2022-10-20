import 'package:flutter/material.dart';
import 'package:podcast_app/widgets/tab_navigator.dart';

class AppKeys {
  static const String SHOW_ON_BOARD = "Onboard";

  static final navigator = TabNavigator(key: navigatorState,name: 'home',);
  static final navigatorState = GlobalKey<NavigatorState>();
  static final panelKey = GlobalKey();
  static final mainScaffoldState = GlobalKey<ScaffoldState>();
  static final collectionsScaffoldState = GlobalKey<ScaffoldState>();
  static final profileScaffoldState = GlobalKey<ScaffoldState>();
  static final searchTfKey = GlobalKey<ScaffoldState>();
  static final searchTfKey1 = GlobalKey<ScaffoldState>();
  static final searchTfKey3 = GlobalKey<ScaffoldState>();
  static final searchTfKey2 = GlobalKey<FormFieldState>();
  static final collectionTfKey = GlobalKey<FormState>();
  static final profileEditTfKey = GlobalKey<FormState>();

}