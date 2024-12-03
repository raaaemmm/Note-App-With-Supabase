import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:note/controllers/notes/note_controller.dart';
import 'package:note/views/screens/create_note_screen.dart';
import 'package:note/views/screens/update_note_screen.dart';
import 'package:readmore/readmore.dart';

class ViewAllNormalNoteScreen extends StatelessWidget {
  ViewAllNormalNoteScreen({super.key});

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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          'All normal notes',
          style: GoogleFonts.kantumruyPro(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              Get.to(
                () => CreateNoteScreen(),
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
                Icons.add,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 15.0),
        ],
      ),
      body: GetBuilder<NoteController>(
        builder: (_) {
          if(_noteController.isGettingNormalNote){
            return Center(
              child: LoadingAnimationWidget.inkDrop(
                color: Theme.of(context).primaryColor,
                size: 15.0,
              ),
            );
          } else if (_noteController.normalNoteList.isEmpty){
            return Center(
              child: Text(
                'No normal note available!',
                style: GoogleFonts.kantumruyPro(
                  fontSize: 13.0,
                  color: Colors.pink,
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await _noteController.getAllNormalNotes();
              },
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: _noteController.normalNoteList.length,
                itemBuilder: (context, index) {
                  final note = _noteController.normalNoteList[index];
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
                                    onPressed: _noteController.isDeletingNote
                                      ? null
                                      : (){
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
                      child: Container(
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
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}