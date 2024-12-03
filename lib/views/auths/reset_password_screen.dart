import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note/controllers/auths/reset_password_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final _resetPWController = Get.put(ResetPasswordController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: GetBuilder<ResetPasswordController>(
              builder: (_) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        'RESET PASSWORD',
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
                      GetBuilder<ResetPasswordController>(
                        builder: (_) {
                          return TextFormField(
                            controller: _resetPWController.emailController,
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
                              suffixIcon: _resetPWController.showAndHideClearButton()
                                ? IconButton(
                                    onPressed: () {
                                      _resetPWController.clearTextField();
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                                    ),
                                  )
                                : null,
                              hintText: 'Enter your email',
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
                            onChanged: (value) {
                              _resetPWController.update();
                            },
                          );
                        }
                      ),
          
                      // Sign-In button
                      const SizedBox(height: 50.0),
                      GestureDetector(
                        onTap: _resetPWController.isResetingPW
                          ? null
                          : (){
                            if(_formKey.currentState!.validate()){
                              _resetPWController.resetPassword();
                            }
                          },
                        child: Container(
                          alignment: Alignment.center,
                          height: 45.0,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: _resetPWController.isResetingPW
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: _resetPWController.isResetingPW
                              ? LoadingAnimationWidget.inkDrop(
                                  color: _resetPWController.isResetingPW
                                    ? Theme.of(context).primaryColor
                                    : Colors.white,
                                  size: 20.0,
                                )
                              : Text(
                                  'Reset',
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
                            'Back',
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