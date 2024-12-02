import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note/controllers/notes/note_controller.dart';
import 'package:note/views/screens/create_note_screen.dart';
import 'package:note/views/screens/search_note_screen.dart';
import 'package:note/views/screens/update_note_screen.dart';
import 'package:readmore/readmore.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key});

  final _noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 70.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notes',
              style: GoogleFonts.kantumruyPro(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Kepp your private notes with us',
              style: GoogleFonts.kantumruyPro(
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: (){
              Get.to(
                () => SearchNoteScreen(),
                transition: Transition.rightToLeftWithFade,
              );
            },
            child: Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 15.0),
        ],
      ),
      body: Column(
        children: [

          // category items
          GetBuilder<NoteController>(
            builder: (_) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 10.0,
                  left: 10.0,
                  right: 10.0,
                ),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    _noteController.noteCategories.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          _noteController.selecteCategory(index);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide.none,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 8.0,
                            ),
                            margin: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              gradient: index == 0
                                  ? LinearGradient(
                                      colors: [
                                        Theme.of(context).primaryColor,
                                        Colors.pink,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    )
                                  : null,
                              color: _noteController.defaultIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              _noteController.noteCategories[index],
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 14.0,
                                color: _noteController.defaultIndex == index
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                fontWeight:
                                    _noteController.defaultIndex == index
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // note items
          Expanded(
            child: GetBuilder<NoteController>(
              builder: (_) {
                if(_noteController.isGettingNotes){
                  return Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: Theme.of(context).primaryColor,
                      size: 15.0,
                    ),
                  );
                } else if (_noteController.noteList.isEmpty){
                  return Center(
                    child: Text(
                      'No note available!',
                      style: GoogleFonts.kantumruyPro(
                        fontSize: 13.0,
                        color: Colors.pink,
                      ),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      if(_noteController.defaultIndex == 0){
                        await _noteController.getAllNotes();
                      } else {
                        await _noteController.getAllNotesByCategory(
                          category: _noteController.noteCategories[_noteController.defaultIndex],
                        );
                      }
                    },
                    color: Theme.of(context).primaryColor,
                    child: ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: _noteController.noteList.length,
                      itemBuilder: (context, index) {
                        final note = _noteController.noteList[index];
                          return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => UpdateNoteScreen(note: note),
                              transition: Transition.rightToLeftWithFade,
                            );
                          },
                          onLongPress: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return GetBuilder<NoteController>(
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
                                        'Are you sure you want to delete this Note? Your note will be delete, and can\'t restore it back!',
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 15.0,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            'No',
                                            style: GoogleFonts.kantumruyPro(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.pink,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _noteController.deleteNote(noteId: note.id);
                                          },
                                          child: Text(
                                            _noteController.isDeletingNote
                                                ? 'Deleting...'
                                                : 'Yes',
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
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide.none,
                            ),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [

                                // notes
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 8.0,
                                  ),
                                  margin: const EdgeInsets.all(3.0),
                                  decoration: BoxDecoration(
                                    color: note.isImportant
                                      ? Colors.pink.withOpacity(0.1)
                                      : Theme.of(context).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      // note title
                                      Text(
                                        note.title,
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 15.0,
                                          color: note.isImportant
                                            ? Colors.pink
                                            : Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          // note description
                                          ReadMoreText(
                                            note.description,
                                            trimLines: 3,
                                            colorClickableText: note.isImportant
                                              ? Colors.pink
                                              : Theme.of(context).primaryColor,
                                            trimMode: TrimMode.Line,
                                            trimCollapsedText: 'More',
                                            trimExpandedText: ' Less',
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.kantumruyPro(
                                              fontSize: 15.0,
                                              color: note.isImportant
                                                ? Colors.pink
                                                : Theme.of(context).primaryColor,
                                            ),
                                            moreStyle: GoogleFonts.kantumruyPro(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: note.isImportant
                                                ? Colors.pink
                                                : Theme.of(context).primaryColor,
                                            ),
                                            lessStyle: GoogleFonts.kantumruyPro(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold,
                                              color: note.isImportant
                                                ? Colors.pink
                                                : Theme.of(context).primaryColor,
                                            ),
                                          ),

                                          // category & created date
                                          const SizedBox(height: 10.0),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                note.category,
                                                style: GoogleFonts.kantumruyPro(
                                                  fontSize: 13.0,
                                                  color: note.isImportant
                                                    ? Colors.pink
                                                    : Theme.of(context).primaryColor,
                                                ),
                                              ),
                                              Text(
                                                _noteController.formatDate(
                                                  createdAt: note.createDate.toLocal().toIso8601String(),
                                                ),
                                                style: GoogleFonts.kantumruyPro(
                                                  fontSize: 12.0,
                                                  color: note.isImportant
                                                    ? Colors.pink
                                                    : Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // check isImportant or not
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    // Left indicator
                                    Container(
                                      width: 5.0,
                                      height: 55.0,
                                      margin: const EdgeInsets.all(3.0),
                                      decoration: BoxDecoration(
                                        color: note.isImportant
                                            ? Colors.pink
                                            : Theme.of(context).primaryColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(8.0),
                                          bottomRight: Radius.circular(8.0),
                                        ),
                                      ),
                                    ),

                                    // Right icon (circle dot) for the first note
                                    if (index == 0)
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                insetPadding: const EdgeInsets.all(30.0),
                                                contentPadding: const EdgeInsets.all(30.0),
                                                title: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.contact_support_sharp,
                                                      color: Theme.of(context).primaryColor,
                                                      size: 30.0,
                                                    ),
                                                    const SizedBox(width: 10.0),
                                                    Text(
                                                      'Remember',
                                                      style: GoogleFonts.kantumruyPro(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ConstrainedBox(
                                                    constraints: const BoxConstraints(
                                                      maxHeight: 200.0,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [

                                                        // Pink color indicator
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: 55.0,
                                                              width: 5.0,
                                                              decoration: const BoxDecoration(
                                                                color: Colors.pink,
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(8.0),
                                                                  bottomRight: Radius.circular(8.0),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 15.0),
                                                            Text(
                                                              'Important Note',
                                                              style: GoogleFonts.kantumruyPro(
                                                                fontSize: 15.0,
                                                                color: Colors.pink,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(height: 15.0),

                                                        // Normal note indicator
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: 55.0,
                                                              width: 5.0,
                                                              decoration: BoxDecoration(
                                                                color: Theme.of(context).primaryColor,
                                                                borderRadius: const BorderRadius.only(
                                                                  topLeft: Radius.circular(8.0),
                                                                  bottomRight: Radius.circular(8.0),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 15.0),
                                                            Text(
                                                              'Normal Note',
                                                              style: GoogleFonts.kantumruyPro(
                                                                fontSize: 15.0,
                                                                color: Theme.of(context).primaryColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: Text(
                                                      'Ok',
                                                      style: GoogleFonts.kantumruyPro(
                                                        fontSize: 15.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Theme.of(context).primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 20.0,
                                          height: 20.0,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: note.isImportant
                                                ? Colors.pink
                                                : Theme.of(context).primaryColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.contact_support_sharp,
                                            color: Colors.white,
                                            size: 15.0,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {          
          Get.to(
            () => CreateNoteScreen(),
            transition: Transition.rightToLeftWithFade,
          );
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}