import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note/controllers/auths/user_controller.dart';
import 'package:note/views/auths/sign_in_screen.dart';
import 'package:note/views/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // store data into local storage device (Offline storage - Local)
  await SharedPreferences.getInstance();

  // store Online Data with Supabase
  await Supabase.initialize(
    url: 'https://your-SupabaseURL', // Supabase URL
    anonKey: 'Your-Project-AnonKey', // Supabase anon key
  );

  runApp(MyApp());
}
        

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _userController = Get.put(UserController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Note App with Supabase as back-end',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF140F2D),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF140F2D)),
      ),
      home: GetBuilder<UserController>(
        builder: (_) => _userController.currentUser != null ? Home() : SignInScreen(),
      ),
    );
  }
}

