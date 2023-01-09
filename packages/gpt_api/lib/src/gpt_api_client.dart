import 'dart:convert';
import 'package:gpt_api/src/models/models.dart';
import 'package:http/http.dart' as http;

class ResponseRequestFailure implements Exception {}

class ResponseNotFoundFailure implements Exception {}

class GPTApiClient {
  static const baseUrl = 'api.openai.com';
  static const path = 'v1/completions';

  GPTApiClient({http.Client? httpClient, String? apiKey})
      : httpClient = httpClient ?? http.Client(),
        apiKey =
            apiKey ?? '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';

  final http.Client httpClient;
  final String apiKey;

  Future<Response> fetchResponse(String text) async {
    final url = Uri.https(baseUrl, path);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey'
    };
    final body = {
      'model': 'text-davinci-003',
      'prompt': text,
      'temperature': 0,
      'top_p': 1,
      'frequency_penalty': 0.0,
      'presence_penalty': 0.0,
      'stop': [' Human', ' AI'],
    };

    final response = await httpClient.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw ResponseRequestFailure();
    }

    final jsonBody = json.decode(response.body) as Map<String, dynamic>;

    if (!(jsonBody.containsKey('choices') &&
        jsonBody['choices'] is List &&
        (jsonBody['choices'][0] as Map<String, dynamic>).containsKey('text'))) {
      throw ResponseNotFoundFailure();
    }

    return Response.fromJson(jsonBody['choices'][0]);
  }
}
