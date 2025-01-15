import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_note/src/services/speech-to-text.dart';

final speechToTextProvider =
    StateNotifierProvider<SpeechToTextNotifier, SpeechToTextState>(
  (ref) => SpeechToTextNotifier(SpeechToTextState()),
);

enum SpeechToTextStatus { initial, loading, success, failure }

class SpeechToTextState {
  final String? message;
  final String? text;
  final String? processingText;
  final SpeechToTextStatus status;
  final bool isListening;

  SpeechToTextState({
    this.text,
    this.message,
    this.processingText,
    this.isListening = false,
    this.status = SpeechToTextStatus.initial,
  });

  SpeechToTextState copyWith({
    String? text,
    bool? isListening,
    SpeechToTextStatus? status,
    String? message,
    String? processingText,
  }) {
    return SpeechToTextState(
      text: text ?? this.text,
      isListening: isListening ?? this.isListening,
      status: status ?? this.status,
      message: message ?? this.message,
      processingText: processingText ?? this.processingText,
    );
  }
}

class SpeechToTextNotifier extends StateNotifier<SpeechToTextState> {
  SpeechToTextNotifier(super.state);

  Future<void> startListening() async {
    try {
      bool hasPermission = await speech.initialize(
        onError: (errorNotification) => debugPrint(
            "sst initalization fail :: ${errorNotification.errorMsg}"),
        debugLogging: true,
        // finalTimeout: const Duration(seconds: 10),
        onStatus: (status) {
          if (status == "listening") {
            print("status listening");
          }
          if (status == "notListening") {
            print("status notListening");
          }
          if (status == "done") {
            print("status done");
            state = state.copyWith(
              isListening: false,
              message: "Successfully listened",
              status: SpeechToTextStatus.success,
              text: state.processingText,
            );
          }
        },
      );

      print("hasPermission :: $hasPermission");

      if (!hasPermission) {
        openAppSettings();
        return;
      }

      print("listening");
      state = state.copyWith(
        isListening: true,
        status: SpeechToTextStatus.loading,
      );

      await speech.listen(
        listenFor: const Duration(seconds: 30),
        onResult: (result) {
          print("result :: $result");
          state = state.copyWith(processingText: result.recognizedWords);
        },
      );
    } catch (e) {
      state = state.copyWith(
        isListening: false,
        message: e.toString(),
        status: SpeechToTextStatus.failure,
      );
    }
  }

  void stopListening() {
    print("stop listening");
    speech.stop();
    state = state.copyWith(
      isListening: false,
      status: SpeechToTextStatus.initial,
    );
  }
}
