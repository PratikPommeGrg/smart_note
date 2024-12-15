import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

enum ImageToTextStateStatus { initial, loading, success, failure }

class ImageToTextState {
  final String? message;
  final ImageToTextStateStatus? status;
  final String? extractedText;

  ImageToTextState({this.message, this.status, this.extractedText});

  factory ImageToTextState.initial() =>
      ImageToTextState(status: ImageToTextStateStatus.initial);
  factory ImageToTextState.loading(bool isLoading) =>
      ImageToTextState(status: ImageToTextStateStatus.loading);
  factory ImageToTextState.success(
          {required String message, required String extractedText}) =>
      ImageToTextState(
          message: message,
          status: ImageToTextStateStatus.success,
          extractedText: extractedText);
  factory ImageToTextState.failure({required String message}) =>
      ImageToTextState(
          message: message,
          status: ImageToTextStateStatus.failure,
          extractedText: null);
}

class ImageToTextNotifier extends StateNotifier<ImageToTextState> {
  ImageToTextNotifier(super.state);

  Future<void> extractText({required String imagePath}) async {
    try {
      state = ImageToTextState.loading(true);

      final textRecognizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
      await textRecognizer.close();

      String text = recognizedText.text.replaceAll(RegExp(r'\s+'), ' ');

      state = ImageToTextState.success(
          message: "Text Extracted", extractedText: text);
    } catch (e) {
      state = ImageToTextState.failure(message: e.toString());
      debugPrint(e.toString());
    }
  }
}

final imageToTextProvider =
    StateNotifierProvider<ImageToTextNotifier, ImageToTextState>(
        (ref) => ImageToTextNotifier(ImageToTextState.initial()));
