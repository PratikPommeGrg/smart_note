import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class PlayTextToSpeech {
  static Future<http.Response> playTextToSpeech(String text) async {
    String brianVoiceId = "nPczCjzI2devNBz1zQrb";

    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$brianVoiceId';
    final String apiKey = dotenv.env['EL_API_KEY'] as String;

    Map<String, String> headers = {
      'accept': 'audio/mpeg',
      'xi-api-key': apiKey,
      'Content-Type': 'application/json',
    };

    final response = await http.post(Uri.parse(url),
        headers: headers,
        body: json.encode(
          {
            'text': text,
            'model_id': 'eleven_monolingual_v1',
            'voice_settings': {
              'stability': 0.5,
              'similarity_boost': 0.7,
            }
          },
        ));

    return response;
  }
}
