import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_note/src/core/error/custom_exceptions.dart';
import 'package:smart_note/src/features/note/models/note_model.dart';
import 'package:smart_note/src/providers/notes_provider/notes_provider.dart';
import 'package:smart_note/src/services/local_storage_service.dart';

enum SingleNoteProviderStatus {
  initial,
  loading,
  success,
  failure,
  editNoteLoading,
  editNoteFailure,
  editNoteSuccess,
}

class SingleNoteProviderState {
  final String? message;
  final SingleNoteProviderStatus status;
  final NoteModel? note;

  SingleNoteProviderState(
      {this.message,
      this.note,
      this.status = SingleNoteProviderStatus.initial});

  factory SingleNoteProviderState.initial() => SingleNoteProviderState();
  factory SingleNoteProviderState.loading() => SingleNoteProviderState(
        message: "Getting note, please wait...",
        status: SingleNoteProviderStatus.loading,
      );

  factory SingleNoteProviderState.failure() => SingleNoteProviderState(
        message: "Failed to get note.",
        status: SingleNoteProviderStatus.failure,
      );

  factory SingleNoteProviderState.success({NoteModel? note}) =>
      SingleNoteProviderState(
        message: "Note got successfully",
        note: note,
        status: SingleNoteProviderStatus.success,
      );
  factory SingleNoteProviderState.editNoteLoading() => SingleNoteProviderState(
        message: "Editing Note, please wait...",
        status: SingleNoteProviderStatus.editNoteLoading,
      );
  factory SingleNoteProviderState.editNoteFailure() => SingleNoteProviderState(
        message: "Failed to edit note",
        status: SingleNoteProviderStatus.editNoteFailure,
      );
  factory SingleNoteProviderState.editNoteSuccess() => SingleNoteProviderState(
        message: "Note edited successfully",
        status: SingleNoteProviderStatus.editNoteSuccess,
      );
}

class SingleNoteProvider extends StateNotifier<SingleNoteProviderState> {
  SingleNoteProvider(super.state, this.ref);

  final Ref ref;

  Future<void> getSingleNote({required int noteId}) async {
    try {
      state = SingleNoteProviderState.loading();

      final result =
          await ref.read(localStorageServiceProvider).getNoteById(noteId);

      state = SingleNoteProviderState.success(note: result);
    } catch (e) {
      state = SingleNoteProviderState.failure();
      throw CustomExceptions(message: e.toString());
    }
  }

  Future<void> editNote() async {
    try {
      NoteModel? note = state.note;

      state = SingleNoteProviderState.editNoteLoading();
      await ref.read(localStorageServiceProvider).insertToTable(
            NoteModel(
              title:
                  ref.read(notesProvider.notifier).titleController.text.trim(),
              note: ref.read(notesProvider.notifier).noteController.text.trim(),
              category: note?.category ?? '',
              id: note?.id,
              cardSize: note?.cardSize,
              images: note?.images,
              isForEdit: true,
            ),
          );

      state = SingleNoteProviderState.editNoteSuccess();
    } catch (e) {
      state = SingleNoteProviderState.editNoteFailure();
      throw CustomExceptions(message: e.toString());
    }
  }
}

final singleNoteProvider =
    StateNotifierProvider<SingleNoteProvider, SingleNoteProviderState>(
        (ref) => SingleNoteProvider(SingleNoteProviderState.initial(), ref));
