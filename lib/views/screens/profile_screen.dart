import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/controllers/auths/update_user_controller.dart';
import 'package:note/controllers/auths/user_controller.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final _userController = Get.put(UserController());
  final _updateUserController = Get.put(UpdateUserController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 70.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.kantumruyPro(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: GetBuilder<UserController>(
        builder: (_) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // user infos
                Text(
                  'Personal information',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                const SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.all(30.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withOpacity(0.1),
                        Colors.pink.withOpacity(0.1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      
                      Shimmer.fromColors(
                        baseColor: Theme.of(context).primaryColor,
                        highlightColor: Colors.pink,
                        child: Text(
                          _userController.currentUser?.displayName ?? '',
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor
                          ),
                        ),
                      ),
                      Text(
                        _userController.currentUser?.email ?? '',
                        style: GoogleFonts.kantumruyPro(
                          fontSize: 15.0,
                          color: Theme.of(context).primaryColor.withOpacity(0.8),
                        ),
                      ),

                      // Short bio: Show only if it exists
                      if (_userController.currentUser?.shortBio != null && _userController.currentUser!.shortBio!.isNotEmpty) 
                        Text(
                          _userController.currentUser!.shortBio!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 13.0,
                            color: Theme.of(context).primaryColor.withOpacity(0.8),
                          ),
                        ),

                      // Date of birth: Show only if it exists
                      if (_userController.currentUser?.dateOfBirth != null)
                        Text(
                          'Birthday 🎂 : ${_userController.formatDate(
                            createdAt: _userController.currentUser!.dateOfBirth!.toLocal().toIso8601String(),
                          )}',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 13.0,
                            color: Theme.of(context).primaryColor.withOpacity(0.8),
                          ),
                        ),

                      // Update Profile button
                      const SizedBox(height: 25.0),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return GetBuilder<UpdateUserController>(
                                initState: (state) {
                                  _updateUserController.initForm(_userController.currentUser!);
                                },
                                builder: (_) {
                                  return AlertDialog(
                                    insetPadding: const EdgeInsets.all(20.0),
                                    contentPadding: const EdgeInsets.all(20.0),
                                    title: Text(
                                      'Edit Profile',
                                      style: GoogleFonts.kantumruyPro(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    content: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxHeight: 280.0,
                                        ),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                        
                                              // display name
                                              TextFormField(
                                                controller: _updateUserController.displayNameController,
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
                                                maxLines: null,
                                              ),

                                              // gender
                                              const SizedBox(height: 8.0),
                                              TextFormField(
                                                controller: _updateUserController.genderController,
                                                keyboardType: TextInputType.text,
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
                                                  hintText: 'Gender',
                                                  hintStyle: GoogleFonts.kantumruyPro(
                                                    fontSize: 15.0,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Oops! please enter your gender...!';
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                              ),

                                              // shortBio
                                              const SizedBox(height: 8.0),
                                              TextFormField(
                                                controller: _updateUserController.shortBioController,
                                                keyboardType: TextInputType.multiline,
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
                                                  hintText: 'Short Bio',
                                                  hintStyle: GoogleFonts.kantumruyPro(
                                                    fontSize: 15.0,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                                maxLines: null,
                                              ),


                                              // date of birth
                                              const SizedBox(height: 8.0),
                                              TextFormField(
                                                controller: _updateUserController.dateOfBirthController,
                                                readOnly: true, // Prevent manual editing
                                                onTap: () async {

                                                  // Open a DatePicker
                                                  DateTime? pickedDate = await showDatePicker(
                                                    barrierDismissible: true,
                                                    barrierColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1900), // Set the minimum year
                                                    lastDate: DateTime.now(), // Set the maximum year
                                                  );
                                                  if (pickedDate != null) {
                                                    // format the picked date and set it to the controller
                                                    _updateUserController.dateOfBirthController.text = _updateUserController.formatDate(pickedDate);
                                                    _updateUserController.update();
                                                  }
                                                },
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
                                                  hintText: 'Date of birth',
                                                  hintStyle: GoogleFonts.kantumruyPro(
                                                    fontSize: 15.0,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          'Cancel',
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if(_updateUserController.isUpdatingUser){
                                            return;
                                          } else {
                                            if (_formKey.currentState!.validate()) {
                                              _updateUserController.updateUser();
                                            } else {
                                              // nothing here
                                            }
                                          }
                                        },
                                        child: Text(
                                          _updateUserController.isUpdatingUser ? 'Updating...' : 'Update',
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 40.0,
                          width: 140.0,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Colors.pink,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Edit Profile',
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Icon(
                                Icons.swipe_up_rounded,
                                color: Colors.white,
                                size: 20.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                // preferences
                const SizedBox(height: 40.0),
                Text(
                  'Preferences',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                // SIGN-OUT button
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return GetBuilder<UserController>(
                          builder: (_) {
                            return AlertDialog(
                              title: Text(
                                'Confirmation',
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              content: Text(
                                'Are you sure, your want to Sign Out?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: 15.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _userController.signOut();
                                  },
                                  child: Text(
                                    _userController.isSignningOut ? 'Signing out...' : 'Ok',
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign Out',
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Icon(
                          Icons.login_rounded,
                          color: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),

                // DELETE ACCOUNT button
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: () {
                    _userController.showMessage(
                      msg: 'Stay tune guyyyy, I\'m working on it!',
                      txtColor: Colors.white,
                      bgColor: Colors.pink,
                      fontSize: 12.0,
                      fontWeight: FontWeight.normal,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 15.0,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.pink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delete Account',
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                        Icon(
                          Icons.delete_forever,
                          color:Colors.pink,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}