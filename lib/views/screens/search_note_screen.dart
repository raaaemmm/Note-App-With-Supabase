import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:note/controllers/notes/note_controller.dart';
import 'package:note/views/screens/update_note_screen.dart';
import 'package:readmore/readmore.dart';

class SearchNoteScreen extends StatelessWidget {
  SearchNoteScreen({super.key});

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
          'Search',
          style: GoogleFonts.kantumruyPro(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [

          // search field
          GetBuilder<NoteController>(
            builder: (_) {
              return Padding(
                padding: const EdgeInsets.only(
                  top: 12.0,
                  left: 12.0,
                  right: 12.0,
                ),
                child: TextField(
                  controller: _noteController.searchController,
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
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).primaryColor,
                    ),
                    suffixIcon: _noteController.showAndHideClearButton()
                        ? IconButton(
                            onPressed: () {
                              _noteController.clearText();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(context).primaryColor.withOpacity(0.7),
                            ),
                          )
                        : null,
                    fillColor: Colors.black.withOpacity(0.1),
                    filled: true,
                    hintText: 'Search',
                    hintStyle: GoogleFonts.kantumruyPro(
                      fontSize: 15.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onChanged: (query) {
                    _noteController.onSearchChanged(query);
                  },
                  onSubmitted: (query) {
                    _noteController.onSearchSubmitted(query);
                  },
                ),
              );
            },
          ),

          // note items
          Expanded(
            child: GetBuilder<NoteController>(
              builder: (_) {
                if (_noteController.searchedList.isEmpty){
                  return Center(
                    child: Column(
                      children: [

                        // show history
                        if(_noteController.searchedHistoryList.isNotEmpty)
                          SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            
                                // title
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Searched History (${_noteController.searchedHistoryList.length})',
                                        style: GoogleFonts.kantumruyPro(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _noteController.removeAllSearchNoteKeywords();
                                        },
                                        child: Text(
                                          'Clear all',
                                          style: GoogleFonts.kantumruyPro(
                                            fontSize: 13.0,
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]
                            )
                          ),
                        
                        // body
                        const SizedBox(height: 10.0),
                        GetBuilder<NoteController>(
                          builder: (_) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Column(
                                children: List.generate(
                                  _noteController.searchedHistoryList.length,
                                  (index) {
                                    final keyword = _noteController.searchedHistoryList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        _noteController.searchController.text = keyword.trim();
                                        _noteController.searchNotes(query: keyword);
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.all(3.0),
                                          width: MediaQuery.of(context).size.width,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0,
                                            vertical: 10.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  keyword,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: GoogleFonts.kantumruyPro(
                                                    fontSize: 15.0,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  _noteController.removeSearchNoteKeyword(keyword);
                                                },
                                                child: Icon(
                                                  Icons.clear_rounded,
                                                  size: 18.0,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            ],
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

                        // no searched note
                        Expanded(
                          child: Center(
                            child: Text(
                              'No note available!',
                              style: GoogleFonts.kantumruyPro(
                                fontSize: 13.0,
                                color: Colors.pink,
                              ),
                            ),
                          ),
                        ),
                      ]   
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: _noteController.searchedList.length,
                    itemBuilder: (context, index) {
                      final note = _noteController.searchedList[index];
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
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}