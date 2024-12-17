import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_note/src/core/enums/enums.dart';
import 'package:smart_note/src/core/states/states.dart';
import 'package:smart_note/src/features/home/view/home_screen.dart';
import 'package:smart_note/src/features/note/models/note_model.dart';
import 'package:smart_note/src/providers/image_provider/image_provider.dart';
import 'package:smart_note/src/services/local_storage_service.dart';

enum NotesStateStatus {
  initial,
  loading,
  success,
  failure,
  deleteLoading,
  deleteSuccess,
  deleteFailure,
  addNoteLoading,
  addNoteSuccess,
  addNoteFailure,
}

class NotesProvideState {
  final String? message;
  final NotesStateStatus status;
  final List<NoteModel> notes;
  final bool? showLoadingIndicator;

  NotesProvideState({
    this.message,
    this.status = NotesStateStatus.initial,
    this.notes = const [],
    this.showLoadingIndicator,
  });

//get
  factory NotesProvideState.initial() => NotesProvideState();
  factory NotesProvideState.loading(
          {required String message, bool? showLoadingIndicator = true}) =>
      NotesProvideState(
        status: NotesStateStatus.loading,
        message: message,
        showLoadingIndicator: showLoadingIndicator,
      );
  factory NotesProvideState.success({
    required List<NoteModel> notes,
    required String message,
  }) =>
      NotesProvideState(
          status: NotesStateStatus.success, notes: notes, message: message);
  factory NotesProvideState.failure({required String message}) =>
      NotesProvideState(status: NotesStateStatus.failure, message: message);

  //delete
  factory NotesProvideState.deleteLoading({String? message}) =>
      NotesProvideState(
        status: NotesStateStatus.deleteLoading,
        message: message ?? 'Deleting Note',
        showLoadingIndicator: false,
      );
  factory NotesProvideState.deleteSuccess({String? message}) =>
      NotesProvideState(
        status: NotesStateStatus.deleteSuccess,
        message: message ?? 'Note Deleted',
        showLoadingIndicator: false,
      );
  factory NotesProvideState.deleteFailure({String? message}) =>
      NotesProvideState(
        status: NotesStateStatus.deleteFailure,
        message: message ?? 'Failed to Delete Note',
        showLoadingIndicator: false,
      );

  //add
  factory NotesProvideState.addNoteLoading({String? message}) =>
      NotesProvideState(
        message: "Adding note, please wait...",
        status: NotesStateStatus.addNoteLoading,
      );
  factory NotesProvideState.addNoteSuccess({String? message}) =>
      NotesProvideState(
        message: "Note Added Successfully",
        status: NotesStateStatus.addNoteSuccess,
      );
  factory NotesProvideState.addNoteFailure({String? message}) =>
      NotesProvideState(
        message: "Failed to Add Note",
        status: NotesStateStatus.addNoteFailure,
      );
}

class NotesProvider extends StateNotifier<NotesProvideState> {
  final Ref ref;
  NotesProvider(super.state, this.ref);

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final GlobalKey<FormState> noteFormKey = GlobalKey<FormState>();

  void reset() {
    titleController.clear();
    noteController.clear();
  }

  Future<void> getNotes(
      {bool? showLoadingIndicator = true, bool? getByCategory}) async {
    try {
      print(
          "filter by category :: $getByCategory, selected Category :: ${selectedCategory.value}");

      state = NotesProvideState.loading(
        message: "Loading Notes",
        showLoadingIndicator: showLoadingIndicator,
      );

//for testing loading case remove later
      if (showLoadingIndicator == true) {
        await Future.delayed(const Duration(milliseconds: 500));
      }

      final List<NoteModel>? notes = getByCategory == true
          ? await ref
              .read(localStorageServiceProvider)
              .getNotesByCategory(selectedCategory.value)
          : await ref.read(localStorageServiceProvider).getAllNotes();

      debugPrint("notes :: $notes");
      state = NotesProvideState.success(
          notes: notes ?? [], message: "Notes Loaded");
    } catch (e) {
      state = NotesProvideState.failure(message: e.toString());
    }
  }

  Future<void> deleteNote(int noteId) async {
    try {
      state = NotesProvideState.deleteLoading(message: "Deleting Note...");

      await ref.read(localStorageServiceProvider).deleteFromTable(noteId);

      state =
          NotesProvideState.deleteSuccess(message: "Note Deleted Successfully");
    } catch (e) {
      state = NotesProvideState.deleteFailure(message: e.toString());
    }
  }

  Future<void> addNote() async {
    try {
      state = NotesProvideState.addNoteLoading();

      List<XFile> attachedImages =
          ref.read(attachedImageProvider.notifier).state;

      await ref.read(localStorageServiceProvider).insertToTable(
            NoteModel(
              title: titleController.text.trim(),
              note: noteController.text.trim(),
              category: ref.read(selectNoteCategoryProvider)?.name ?? '',
              images: attachedImages.isNotEmpty
                  ? attachedImages.map((e) => e.path).toList()
                  : null,
              cardSize: generategenerateMaxAxisCellCount().toDouble(),
            ),
          );
      state = NotesProvideState.addNoteSuccess();
    } catch (e) {
      state = NotesProvideState.addNoteFailure();
    }
  }
}

final notesProvider = StateNotifierProvider<NotesProvider, NotesProvideState>(
  (ref) => NotesProvider(NotesProvideState.initial(), ref),
);

final selectNoteCategoryProvider =
    StateProvider<NoteCategoryEnum?>((ref) => null);
