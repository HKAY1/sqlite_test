import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/models/notes_model.dart';
import 'package:test_app/service/internet_service.dart';

import '../db/db.dart';
import '../models/synced_notes_model.dart';

class NotesProvider extends StateNotifier<NotesState> {
  static final NotesProvider instance = NotesProvider._();

  NotesProvider._() : super(NotesInitial());

  final AppDatabase noteDatabase = AppDatabase.instance;

  Future<void> fetchNotes() async {
    state = NotesLoading();
    final notes = await noteDatabase.readAll();
    state = NotesFetch(notes);
  }

  Future<List<NoteModel>> fetchUnsynedNotes() async {
    return await noteDatabase.readAll1(true);
  }

  Future<void> createNote() async {
    state = NotesLoading();
    final model = NoteModel(
      title: "John Doe",
      number: 1,
      content: "Some content",
      isFavorite: false,
      isSynced: false,
      createdTime: DateTime.now(),
    );

    await noteDatabase.create(model);

    await syncNote(model);
  }

  Future<void> updateNote(NoteModel note) async {
    await noteDatabase.update(note);
  }

  Future<void> syncNote(NoteModel note) async {
    if (InternetConnectivity.instance.connectionState()) {
      print("in providr for syncing");
      final SyncedNotesModel notes = SyncedNotesModel(
          title: note.title,
          content: note.content,
          isFavorite: note.isFavorite,
          createdTime: DateTime.now(),
          number: 1);
      await noteDatabase.syncCreate(notes);
      final newNote = note.copyWith(isSynced: true);
      await updateNote(newNote);
    }

    final notes = await noteDatabase.readAll();
    state = NotesFetch(notes);
  }
}

final notesProvider = StateNotifierProvider<NotesProvider, NotesState>(
    (ref) => NotesProvider.instance);

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object?> get props => [];
}

final class NotesInitial extends NotesState {}

final class NotesLoading extends NotesState {}

final class NotesFetch extends NotesState {
  const NotesFetch(this.notes);

  final List<NoteModel> notes;

  @override
  List<List<NoteModel>?> get props => <List<NoteModel>>[notes];
}

final class NotesError extends NotesState {}
