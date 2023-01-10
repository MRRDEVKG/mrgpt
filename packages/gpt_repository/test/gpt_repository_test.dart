import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_repository/gpt_repository.dart';
import 'package:gpt_api/gpt_api.dart' as api;
import 'package:mocktail/mocktail.dart';

class MockGPTApiClient extends Mock implements api.GPTApiClient {}

void main() {
  group('GPTRepository', () {
    late api.GPTApiClient gptApiClient;
    late GPTRepository gptRepository;

    setUp(() {
      gptApiClient = MockGPTApiClient();
      gptRepository = GPTRepository(gptApiClient: gptApiClient);
    });

    test('GPTRepository without parameters', () {
      expect(GPTRepository(), isNotNull);
    });

    test('fetchResponse', () async{
      when(() => gptApiClient.fetchResponse(any())).thenAnswer(
          (invocation) => Future.value(const api.Response(text: 'test')));
      
      expect(await gptRepository.getResponse('test'), isA<Response>().having((r) => r.text, 'text', 'test'));
    });
  });
}
