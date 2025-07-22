import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:note/controllers/auths/user_controller.dart';
import 'package:note/views/auths/sign_in_screen.dart';
import 'package:note/views/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(
    fileName: ".env",
    isOptional: false,
  );

  // Store data into local storage device (Offline storage - Local)
  await SharedPreferences.getInstance();

  // Store Online Data with Supabase using environment variables
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
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
      title: dotenv.env['APP_NAME'] ?? 'Note App',
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