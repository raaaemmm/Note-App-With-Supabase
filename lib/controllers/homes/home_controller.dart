import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/views/screens/note_screen.dart';
import 'package:note/views/screens/profile_screen.dart';

class HomeController extends GetxController {

  // default index
  int defaultIndex = 0;

  // list screens
  List<Widget> screens = [
    NoteScreen(),
    ProfileScreen(),
  ];

  // selected index
  void selectedIndex(newIndex) {
    defaultIndex = newIndex;
    update();
  }
}