import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note/controllers/auths/update_user_controller.dart';
import 'package:note/controllers/auths/user_controller.dart';
import 'package:note/controllers/notes/note_controller.dart';
import 'package:note/views/auths/sign_in_screen.dart';
import 'package:note/views/screens/view_all_important_note_screen.dart';
import 'package:note/views/screens/view_all_normal_note_screen.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final _userController = Get.put(UserController());
  final _updateUserController = Get.put(UpdateUserController());
  final _formKey = GlobalKey<FormState>();

  final _noteController = Get.put(NoteController());

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
            fontSize: 18.0,
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
                    fontSize: 15.0,
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
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        Colors.pink.withValues(alpha: 0.1),
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
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                        ),
                      ),

                      // Short bio: Show only if it exists
                      if (_userController.currentUser?.shortBio != null && _userController.currentUser!.shortBio!.isNotEmpty) 
                        Text(
                          _userController.currentUser!.shortBio!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kantumruyPro(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                          ),
                        ),

                      // Date of birth: Show only if it exists
                      if (_userController.currentUser?.dateOfBirth != null && _userController.currentUser!.dateOfBirth!.toIso8601String().isNotEmpty)
                        Column(
                          children: [

                            const SizedBox(height: 10.0),
                            Text(
                              '🎂 Birthday 🎉',
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              _userController.formatDate(
                                createdAt: _userController.currentUser!.dateOfBirth!.toLocal().toIso8601String(),
                              ),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 13.0,
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),

                      // Update Profile button
                      const SizedBox(height: 20.0),
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
                                                  fillColor: Colors.black.withValues(alpha: 0.1),
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
                                                  fillColor: Colors.black.withValues(alpha: 0.1),
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
                                                  fillColor: Colors.black.withValues(alpha: 0.1),
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
                                                    barrierColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
                                                  fillColor: Colors.black.withValues(alpha: 0.1),
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
                                        onPressed: _updateUserController.isUpdatingUser
                                          ? null
                                          : (){
                                            if(_formKey.currentState!.validate()){
                                              _updateUserController.updateUser();
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

                // contents
                const SizedBox(height: 30.0),
                Text(
                  'Contents',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),

                // important note
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: _noteController.importantNoteList.isEmpty
                    ? null
                    : (){
                      Get.to(
                        () => ViewAllImportantNoteScreen(),
                        transition: Transition.rightToLeftWithFade,
                      );
                    },
                  child: GetBuilder<NoteController>(
                    builder: (_) {

                      // track  count importantNoteList
                      int count = _noteController.importantNoteList.length;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.pink.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: _noteController.isGettingImportantNote
                        ? LoadingAnimationWidget.inkDrop(
                            color: Colors.pink,
                            size: 15.0,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                count == 0
                                    ? 'Oops, 🤭 no important note available!'
                                    : 'Important ${count == 1 ? 'note' : 'notes'} ($count)',
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 15.0,
                                  fontWeight: count == 0
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                  color: Colors.pink,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    count == 0 ? '' : 'View all',
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: 13.0,
                                      color: Colors.pink,
                                    ),
                                  ),
                                  if (count > 0) ...[
                                    const SizedBox(width: 5.0),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.pink,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                      );
                    },
                  ),
                ),

                // normal note
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: _noteController.normalNoteList.isEmpty
                    ? null
                    : (){
                      Get.to(
                        () => ViewAllNormalNoteScreen(),
                        transition: Transition.rightToLeftWithFade,
                      );
                    },
                  child: GetBuilder<NoteController>(
                    builder: (_) {

                      // track  count normalNoteList
                      int count = _noteController.normalNoteList.length;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: _noteController.isGettingNormalNote
                        ? LoadingAnimationWidget.inkDrop(
                            color: Theme.of(context).primaryColor,
                            size: 15.0,
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                count == 0
                                    ? 'Oops, 🤭 no normal note available!'
                                    : 'Normal ${count == 1 ? 'note' : 'notes'} ($count)',
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 15.0,
                                  fontWeight: count == 0
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    count == 0 ? '' : 'View all',
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: 13.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  if (count > 0) ...[
                                    const SizedBox(width: 5.0),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                      );
                    },
                  ),
                ),

                // save & export all notes into Excel
                const SizedBox(height: 10.0),
                GestureDetector(
                  onTap: _noteController.noteList.isEmpty || _noteController.isExporting
                      ? null
                      : () {
                          _noteController.exportAllNotesToExcel();
                        },
                  child: GetBuilder<NoteController>(
                    builder: (_) {

                      // track count noteList
                      int count = _noteController.noteList.length;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 15.0,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: _noteController.isGettingNotes
                            ? LoadingAnimationWidget.inkDrop(
                                color: Theme.of(context).primaryColor,
                                size: 15.0,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _noteController.isExporting
                                        ? 'Exporting...'
                                        : count == 0
                                            ? 'Oops, 🤭 no note available!'
                                            : 'Export ${count == 1
                                                ? '($count) note' 
                                                : 'all ($count) notes'} to Excel file',
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: 15.0,
                                      fontWeight: count == 0
                                        ? FontWeight.normal 
                                        : FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  if (count > 0) ...[
                                    _noteController.isExporting
                                        ? LoadingAnimationWidget.inkDrop(
                                            color: Theme.of(context).primaryColor,
                                            size: 15.0,
                                          )
                                        : Icon(
                                            Icons.import_export_rounded,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                  ],
                                ],
                              ),
                      );
                    },
                  ),
                ),

                // preferences
                const SizedBox(height: 30.0),
                Text(
                  'Preferences',
                  style: GoogleFonts.kantumruyPro(
                    fontSize: 15.0,
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
                                    _userController.signOut().whenComplete(
                                      () => Get.offAll(() => SignInScreen()),
                                    );
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
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
                      color: Colors.red.withValues(alpha: 0.1),
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
                            color: Colors.red,
                          ),
                        ),
                        Icon(
                          Icons.delete_forever,
                          color:Colors.red,
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