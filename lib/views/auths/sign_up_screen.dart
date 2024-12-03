import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note/controllers/auths/sign_up_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _signUpController = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: GetBuilder<SignUpController>(
              builder: (_) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        'SIGN-UP',
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'Fill your credential below 👋',
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 13.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),

                      // display name
                      const SizedBox(height: 120.0),
                      TextFormField(
                        controller: _signUpController.displaynameController,
                        keyboardType: TextInputType.name,
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 15.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: GoogleFonts.kantumruyPro(
                            fontSize: 13.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          fillColor: Colors.black.withOpacity(0.1),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                          hintText: 'Name',
                          hintStyle: GoogleFonts.kantumruyPro(
                            fontSize: 15.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Oops! please enter your name...!';
                          } else {
                            return null;
                          }
                        },
                      ),
          
                      // email
                      const SizedBox(height: 10.0),
                      TextFormField(
                        controller: _signUpController.emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 15.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: GoogleFonts.kantumruyPro(
                            fontSize: 13.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          fillColor: Colors.black.withOpacity(0.1),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.email,
                            color: Theme.of(context).primaryColor,
                          ),
                          hintText: 'Email',
                          hintStyle: GoogleFonts.kantumruyPro(
                            fontSize: 15.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Oops! please enter your email...!';
                          } else {
                            return null;
                          }
                        },
                      ),
          
                      // password
                      const SizedBox(height: 10.0),
                      TextFormField(
                        obscureText: _signUpController.obscureText,
                        controller: _signUpController.passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 15.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        cursorColor: Theme.of(context).primaryColor,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: GoogleFonts.kantumruyPro(
                            fontSize: 13.0,
                            color: Theme.of(context).primaryColor,
                          ),
                          fillColor: Colors.black.withOpacity(0.1),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.password_rounded,
                            color: Theme.of(context).primaryColor,
                          ),
                          suffixIcon: IconButton(
                            highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            hoverColor: Theme.of(context).primaryColor,
                            onPressed: () {
                              _signUpController.showAndHidePassword();
                            },
                            icon: Icon(
                              _signUpController.obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                            ),
                          ),
                          hintText: 'Password',
                          hintStyle: GoogleFonts.kantumruyPro(
                            fontSize: 15.0,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Oops! please enter your password...!';
                          } else {
                            return null;
                          }
                        },
                      ),
          
                      // Sign-In button
                      const SizedBox(height: 50.0),
                      GestureDetector(
                        onTap: _signUpController.isSignningUp
                          ? null
                          : (){
                            if(_formKey.currentState!.validate()){
                              _signUpController.signUp();
                            }
                          },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: _signUpController.isSignningUp
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: _signUpController.isSignningUp
                              ? LoadingAnimationWidget.inkDrop(
                                  color: _signUpController.isSignningUp
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                  size: 20.0,
                                )
                              : Text(
                                  'Sign Up',
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
          
                      // SIGN-IN button
                      const SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 15.0,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}