import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';

stt.SpeechToText speech = stt.SpeechToText();

Future<List<LocaleName>> getLocales() async => await speech.locales();
