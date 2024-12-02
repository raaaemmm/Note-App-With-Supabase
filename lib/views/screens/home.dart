import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/controllers/homes/home_controller.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final _homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (_) {
        return Scaffold(
          body: _homeController.screens[_homeController.defaultIndex],
          bottomNavigationBar: NavigationBarTheme(
            data: NavigationBarThemeData(
              labelTextStyle: WidgetStateProperty.all(
                GoogleFonts.kantumruyPro(
                  fontSize: 15.0,
                ),
              ),
            ),
            child: NavigationBar(
              height: 60.0,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              indicatorColor:  Theme.of(context).primaryColor.withOpacity(0.1),
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              selectedIndex: _homeController.defaultIndex,
              elevation: 0,
              onDestinationSelected: (newIndex) {
                _homeController.selectedIndex(newIndex);
              },
              destinations: [

                // notes
                NavigationDestination(
                  icon: Icon(
                    Icons.edit_note_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  selectedIcon: Icon(
                    Icons.edit_note_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: 'Note',
                ),

                // profile
                NavigationDestination(
                  icon: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  selectedIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: 'Profile',
                ),
              ]
            ),
          ),
        );
      },
    );
  }
}