import 'package:flutter_test/flutter_test.dart';
import 'package:gpt_api/gpt_api.dart';

void main() {
  group('Response', () {
    test('Response constructor', () {
      Response response = const Response(text: 'test');
      expect(response.text, 'test');
    });

    test('fromJson factory constructor', () {
      Response response = Response.fromJson({'text': 'test'});
      expect(response.text, 'test');
    });

    test('toJson method', () {
      Response response = const Response(text: 'test');
      expect(response.toJson(),
          isA<Map<String, dynamic>>().having((r) => r['text'], 'text', 'test'));
    });
  });
}
