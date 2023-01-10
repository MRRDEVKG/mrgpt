import 'package:gpt_api/gpt_api.dart' as gpt;
import 'models/response.dart';

class GPTRepository {
  GPTRepository({gpt.GPTApiClient? gptApiClient})
      : _gptApiClient = gptApiClient ?? gpt.GPTApiClient();
  final gpt.GPTApiClient _gptApiClient;

  Future<Response> getResponse(String text) async {
    final response = await _gptApiClient.fetchResponse(text);
    return Response(text: response.text);
  }
}
