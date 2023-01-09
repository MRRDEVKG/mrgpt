import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_api/gpt_api.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockHttpResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

class FakeMap extends Fake implements Map {}

void main() {
  group('GPTApiClient', () {
    late http.Client httpClient;
    late http.Response httpResponse;
    late GPTApiClient gptApiClient;

    setUpAll(() {
      registerFallbackValue(FakeUri());
      registerFallbackValue(FakeMap());
    });

    setUp(() {
      httpClient = MockHttpClient();
      httpResponse = MockHttpResponse();
      gptApiClient = GPTApiClient(httpClient: httpClient);
    });

    test('GPTApiClient constructor without parameters', () {
      expect(GPTApiClient(), isNotNull);
    });

    test('throws ResponseRequestFailure on non-200 response', () {
      when(() => httpResponse.statusCode).thenReturn(400);
      when(() => httpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((invocation) => Future.value(httpResponse));

      expect(gptApiClient.fetchResponse('test'),
          throwsA(isA<ResponseRequestFailure>()));
    });

    test('throws ResponseNotFoundFailure on empty response', () {
      when(() => httpResponse.statusCode).thenReturn(200);
      when(() => httpResponse.body).thenReturn('{}');
      when(() => httpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((invocation) => Future.value(httpResponse));

      expect(gptApiClient.fetchResponse('test'),
          throwsA(isA<ResponseNotFoundFailure>()));
    });

    test('returns response on valid response', () async{
      when(() => httpResponse.statusCode).thenReturn(200);
      when(() => httpResponse.body).thenReturn(
          json.encode({'choices': <Map<String, dynamic>>[{'text': 'Manasbek', 'test':'Nothing'}]}));

      when(() => httpClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((invocation) => Future(() => httpResponse));

      expect(await gptApiClient.fetchResponse('test'),
          isA<Response>().having((r) => r.text, 'response text', 'Manasbek'));
    });
  });
}
