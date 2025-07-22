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
                return Column(
                  children: [

                    // Sign Up Form
                    Form(
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
                              fillColor: Colors.black.withValues(alpha: 0.1),
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
                              fillColor: Colors.black.withValues(alpha: 0.1),
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
                              } else if (!GetUtils.isEmail(value)) {
                                return 'Please enter a valid email address';
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
                              fillColor: Colors.black.withValues(alpha: 0.1),
                              filled: true,
                              prefixIcon: Icon(
                                Icons.password_rounded,
                                color: Theme.of(context).primaryColor,
                              ),
                              suffixIcon: IconButton(
                                highlightColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                hoverColor: Theme.of(context).primaryColor,
                                onPressed: () {
                                  _signUpController.showAndHidePassword();
                                },
                                icon: Icon(
                                  _signUpController.obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
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
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              } else {
                                return null;
                              }
                            },
                          ),
              
                          // Sign-Up button
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
                                  ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
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
                              _signUpController.hideEmailConfirmationAlert();
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
                    ),

                    // email confirmation Alert
                    if (_signUpController.showEmailConfirmationAlert) ...[
                      const SizedBox(height: 20.0),
                      Container(
                        margin: EdgeInsets.only(bottom: 20.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          border: Border.all(color: Colors.orange),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: Colors.orange,
                                  size: 24.0,
                                ),
                                SizedBox(width: 12.0),
                                Expanded(
                                  child: Text(
                                    'Please confirm your email',
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _signUpController.hideEmailConfirmationAlert,
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'We\'ve sent a confirmation email to ${_signUpController.pendingConfirmationEmail}. Please check your inbox and click the confirmation link to activate your account.',
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 13.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: 12.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: _signUpController.resendEmailConfirmation,
                                  child: Text(
                                    'Resend Email',
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _signUpController.hideEmailConfirmationAlert();
                                    Get.back(); // Go back to sign in
                                  },
                                  child: Text(
                                    'Back to Sign In',
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}