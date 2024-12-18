import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:smart_note/src/helper/custom_audio_source.dart';

import '../../helper/play_text_to_speech.dart';

enum TextToSpeechStatus { initial, loading, success, failure }

class TextToSpeechState {
  final String? message;
  final TextToSpeechStatus status;

  TextToSpeechState({this.message, this.status = TextToSpeechStatus.initial});

  factory TextToSpeechState.initail() => TextToSpeechState();
  factory TextToSpeechState.loading() =>
      TextToSpeechState(status: TextToSpeechStatus.loading, message: "Loading");
  factory TextToSpeechState.success({String? message}) =>
      TextToSpeechState(status: TextToSpeechStatus.success, message: "Success");
  factory TextToSpeechState.failure({String? message}) =>
      TextToSpeechState(status: TextToSpeechStatus.failure, message: message);
}

class TextToSpeechProvider extends StateNotifier<TextToSpeechState> {
  final Ref ref;

  TextToSpeechProvider(super.state, this.ref);
  static final player = AudioPlayer();

  Future<void> textToSpeech(String text) async {
    try {
      state = TextToSpeechState.loading();

      final response = await PlayTextToSpeech.playTextToSpeech(text);

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        await player.setAudioSource(CustomAudioSource(bytes: bytes));
        state = TextToSpeechState.success();
        await player.play();
        state = TextToSpeechState.initail();
      } else {
        state = TextToSpeechState.failure(message: response.reasonPhrase);
      }
    } catch (e) {
      state = TextToSpeechState.failure(message: e.toString());
    }
  }
}

final textToSpeechProvider =
    StateNotifierProvider<TextToSpeechProvider, TextToSpeechState>(
  (ref) {
    return TextToSpeechProvider(TextToSpeechState.initail(), ref);
  },
);
