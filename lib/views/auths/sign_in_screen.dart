import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note/controllers/auths/sign_in_controller.dart';
import 'package:note/views/auths/reset_password_screen.dart';
import 'package:note/views/auths/sign_up_screen.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final _signInController = Get.put(SignInController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: GetBuilder<SignInController>(
              builder: (_) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        'SIGN-IN',
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
          
                      // email
                      const SizedBox(height: 120.0),
                      TextFormField(
                        controller: _signInController.emailController,
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
                        obscureText: _signInController.obscureText,
                        controller: _signInController.passwordController,
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
                              _signInController.showAndHidePassword();
                            },
                            icon: Icon(
                              _signInController.obscureText
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
                      SizedBox(height: 50.0),
                      GestureDetector(
                        onTap: _signInController.isSignningIn
                          ? null
                          : (){
                            if(_formKey.currentState!.validate()){
                              _signInController.signIn();
                            }
                          },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: _signInController.isSignningIn
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: _signInController.isSignningIn
                              ? LoadingAnimationWidget.inkDrop(
                                  color: _signInController.isSignningIn
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                  size: 20.0,
                                )
                              : Text(
                                  'Sign In',
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
          
                      // forgot password button
                      const SizedBox(height: 10.0),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Get.to(
                              () => ResetPasswordScreen(),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.kantumruyPro(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
          
                      // SIGN-UP button
                      const SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => SignUpScreen(),
                            transition: Transition.rightToLeftWithFade,
                          );
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
                            'Sign Up new account',
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
