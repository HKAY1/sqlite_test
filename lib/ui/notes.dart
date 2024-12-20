import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:test_app/db/db.dart';
import 'package:test_app/locale.dart';
import 'package:test_app/provider/notes_provider.dart';
// import 'package:test_app/service/bio_auth_service.dart';

import '../models/notes_model.dart';
import '../models/user_model.dart';
import '../provider/app_locale_provider.dart';

class NotesView extends StatelessWidget {
  final UserModel user;
  const NotesView({super.key, required this.user});

  ///Gets all the notes from the database and updates the state

  ///Navigates to the NoteDetailsView and refreshes the notes after the navigation

  @override
  Widget build(BuildContext context) {
    // appLanguage = Provider.of<AppLanguageProvider>(context);

    goToNoteDetailsView({int? id}) async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NoteDetailsView(noteId: id)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: false,
        title: Text(
          "${AppLocalizations.of(context)!.translate('textToChange')!} ${user.phoneNumber}",
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () => NotesProvider.instance.fetchNotes(),
              icon: const Icon(Icons.refresh)),
          Consumer(builder: (context, ref, ch) {
            return PopupMenuButton<int>(
              color: Colors.white,
              iconColor: Colors.white,
              itemBuilder: (context) => [
                // PopupMenuItem 1
                const PopupMenuItem(
                  value: 1,
                  // row with 2 children
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.abc,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("English")
                    ],
                  ),
                ),
                // PopupMenuItem 2
                const PopupMenuItem(
                  value: 2,
                  // row with two children
                  child: Row(
                    children: [
                      Icon(Icons.nearby_off),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Hindi")
                    ],
                  ),
                ),
              ],
              elevation: 2,
              onSelected: (value) {
                if (value == 1) {
                  ref
                      .read(appLocalProvider.notifier)
                      .changeLanguage(const Locale("en"));
                } else if (value == 2) {
                  ref
                      .read(appLocalProvider.notifier)
                      .changeLanguage(const Locale("hi"));
                }
              },
            );
          }),
        ],
      ),
      body: Center(
        child: Consumer(builder: (context, ref, child) {
          final state = ref.watch(notesProvider);
          if (state is NotesLoading) return const CircularProgressIndicator();
          if (state is NotesFetch) {
            return ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return GestureDetector(
                    onTap: () => goToNoteDetailsView(id: note.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                note.createdTime.toString().split(' ')[0],
                              ),
                              Text(
                                note.title,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: note.isSynced
                                        ? Colors.green
                                        : Colors.red),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
          return Container();
        }),
      ),
      floatingActionButton: Consumer(builder: (context, ref, ch) {
        return FloatingActionButton(
          onPressed:
              // () async {
              //   final res = await BioAuthService.instance.authenticate();
              //   print(res);
              // },
              () => ref.read(notesProvider.notifier).createNote(),
          tooltip: 'Create Note',
          child: const Icon(Icons.add),
        );
      }),
    );
  }
}

class NoteDetailsView extends StatefulWidget {
  const NoteDetailsView({super.key, this.noteId});
  final int? noteId;

  @override
  State<NoteDetailsView> createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends State<NoteDetailsView> {
  AppDatabase noteDatabase = AppDatabase.instance;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  late NoteModel note;
  bool isLoading = false;
  bool isNewNote = false;
  bool isFavorite = false;

  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  ///Gets the note from the database and updates the state if the noteId is not null else it sets the isNewNote to true
  refreshNotes() {
    if (widget.noteId == null) {
      setState(() {
        isNewNote = true;
      });
      return;
    }
    noteDatabase.read(widget.noteId!).then((value) {
      setState(() {
        note = value;
        titleController.text = note.title;
        contentController.text = note.content;
        isFavorite = note.isFavorite;
      });
    });
  }

  ///Creates a new note if the isNewNote is true else it updates the existing note
  createNote() {
    setState(() {
      isLoading = true;
    });
    final model = NoteModel(
      title: titleController.text,
      number: 1,
      content: contentController.text,
      isFavorite: isFavorite,
      createdTime: DateTime.now(),
    );
    if (isNewNote) {
      noteDatabase.create(model);
    } else {
      model.id = note.id;
      noteDatabase.update(model);
    }
    setState(() {
      isLoading = false;
    });
  }

  ///Deletes the note from the database and navigates back to the previous screen
  deleteNote() {
    noteDatabase.delete(note.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: Icon(!isFavorite ? Icons.favorite_border : Icons.favorite,
                color: Colors.redAccent),
          ),
          Visibility(
            visible: !isNewNote,
            child: IconButton(
              onPressed: deleteNote,
              icon: const Icon(Icons.delete),
            ),
          ),
          IconButton(
            onPressed: () {
              createNote();
            },
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(children: [
                  TextField(
                    controller: titleController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextField(
                    controller: contentController,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Type your note here...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ]),
        ),
      ),
    );
  }
}
