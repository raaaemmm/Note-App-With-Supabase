import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note/controllers/auths/new_password_controller.dart';
import 'package:note/views/auths/sign_in_screen.dart';

class NewPasswordScreen extends StatelessWidget {
  NewPasswordScreen({super.key, required this.code});

  // this is the code (use code instead of token) passed via deep link
  final String code;
  final _newPWController = Get.put(NewPasswordController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          onPressed: () {
            Get.offAll(
              ()=> SignInScreen(),
              transition: Transition.rightToLeftWithFade,
            );
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: GetBuilder<NewPasswordController>(
              builder: (_) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        'UPDATE PASSWORD',
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'Enter your new password below 👋',
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 13.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
          
                      // new password fields
                      const SizedBox(height: 120.0),
                      GetBuilder<NewPasswordController>(
                        builder: (_) {
                          return Column(
                            children: [

                              // password
                              TextFormField(
                                obscureText: _newPWController.obscureText,
                                controller: _newPWController.newPasswordController,
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
                                      _newPWController.showAndHidePassword();
                                    },
                                    icon: Icon(
                                      _newPWController.obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                                    ),
                                  ),
                                  hintText: 'New password',
                                  hintStyle: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Oops! please enter your new password...!';
                                  } else if (value.length < 6) {
                                    return 'Oops, password must be at least 6 characters...!';
                                  }
                                  return null;
                                },
                              ),

                              // confirm password
                              const SizedBox(height: 10.0),
                              TextFormField(
                                obscureText: _newPWController.obscureTextConfirmPassword,
                                controller: _newPWController.confirmPasswordController,
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
                                      _newPWController.showAndHideConfirmPassword();
                                    },
                                    icon: Icon(
                                      _newPWController.obscureTextConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                                    ),
                                  ),
                                  hintText: 'Confirm new password',
                                  hintStyle: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Oops! please enter your new confirm password...!';
                                  } else if (value.length < 6) {
                                    return 'Oops, password must be at least 6 characters...!';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          );
                        }
                      ),
          
                      // save new password button
                      const SizedBox(height: 50.0),
                      GestureDetector(
                        onTap: _newPWController.isHandlingPasswordReset
                          ? null
                          : (){
                            if(_formKey.currentState!.validate()){
                              _newPWController.handlePasswordReset();
                            }
                          },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: _newPWController.isHandlingPasswordReset
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: _newPWController.isHandlingPasswordReset
                              ? LoadingAnimationWidget.inkDrop(
                                  color: _newPWController.isHandlingPasswordReset
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                  size: 20.0,
                                )
                              : Text(
                                  'Save',
                                  style: GoogleFonts.kantumruyPro(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
          
                      // back button
                      const SizedBox(height: 30.0),
                      GestureDetector(
                        onTap: () {
                          Get.offAll(
                            ()=> SignInScreen(),
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
                            'Back to Sign-In',
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
