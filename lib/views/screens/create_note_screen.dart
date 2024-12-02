import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note/controllers/notes/create_note_controller.dart';

class CreateNoteScreen extends StatelessWidget {
  CreateNoteScreen({super.key});

  final _createNoteController = Get.put(CreateNoteController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        elevation: 0.0,
        toolbarHeight: 60.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Create note',
          style: GoogleFonts.kantumruyPro(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: GetBuilder<CreateNoteController>(
        builder: (_) {
          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [                

                // note form
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [

                        // title
                        TextFormField(
                          controller: _createNoteController.titleController,
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
                            hintText: 'Title',
                            hintStyle: GoogleFonts.kantumruyPro(
                              fontSize: 15.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Oops! please enter your Title...!';
                            } else {
                              return null;
                            }
                          },
                          maxLines: null,
                        ),
            
                        // decscription
                        const SizedBox(height: 10.0),
                        TextFormField(
                          controller: _createNoteController.descriptionController,
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
                            hintText: 'Description',
                            hintStyle: GoogleFonts.kantumruyPro(
                              fontSize: 15.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Oops! please enter your description...!';
                            } else {
                              return null;
                            }
                          },
                          maxLines: null,
                          minLines: 5,
                        ),
            
                        const SizedBox(height: 10.0),
                        Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(left: 15.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
            
                              // text
                              Row(
                                children: [
                                  Icon(
                                    Icons.category_rounded,
                                    size: 20.0,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  const SizedBox(width: 13.0),
                                  Text(
                                    _createNoteController.selectedCategory.isEmpty
                                        ? 'Select category'
                                        : _createNoteController.selectedCategory,
                                    style: GoogleFonts.kantumruyPro(
                                      fontSize: 15.0,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
            
                              // select category button
                              PopupMenuButton<String>(
                                color: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: Theme.of(context).primaryColor,
                                ),
                                itemBuilder: (context) {
                                  return _createNoteController.categoryOptions.map((String category) {
                                    return PopupMenuItem<String>(
                                      enabled: true,
                                      value: category,
                                      child: Text(
                                        category,
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 15.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                onSelected: (selectedCategory) {
                                  _createNoteController.selectCategory(category: selectedCategory);
                                },
                              ),
                            ],
                          ),
                        ),
            
                        // check is important or not
                        const SizedBox(height: 10.0),
                        GestureDetector(
                          onTap: () {
                            _createNoteController.toggleImportance();
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Is it important?',
                                style: GoogleFonts.kantumruyPro(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold,
                                  color: _createNoteController.isImportant
                                    ? Colors.pink
                                    : Theme.of(context).primaryColor,
                                ),
                              ),
                              const SizedBox(width: 5.0),
                              Transform.scale(
                                scale: 1.2,
                                child: Checkbox(
                                  value: _createNoteController.isImportant,
                                  onChanged: (bool? newValue) {
                                    _createNoteController.toggleImportance();
                                  },
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1.5,
                                  ),
                                  activeColor: Colors.pink,
                                  checkColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                // create note button
                GestureDetector(
                  onTap: () {
                    if(_createNoteController.isCreating){
                      return;
                    } else {
                      if (_formKey.currentState!.validate()) {
                        _createNoteController.createNote();
                      } else {
                        // nothing here
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 45.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: _createNoteController.isCreating
                          ? LoadingAnimationWidget.inkDrop(
                              color: Colors.white,
                              size: 20.0,
                            )
                          : Text(
                              'Create',
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}