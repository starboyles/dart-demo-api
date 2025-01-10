import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'dart:convert';

void main() {
  final baseUrl = 'http://localhost:8080';

  group('API Tests', () {
    test('GET / returns hello message', () async {
      final response = await http.get(Uri.parse(baseUrl));
      expect(response.statusCode, equals(200));
      expect(response.body, equals('Hello, Dart API!'));
    });

    test('GET /health returns OK', () async {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      expect(response.statusCode, equals(200));
      expect(response.body, equals('OK'));
    });

    test('POST / with JSON data returns processed response', () async {
      final testData = {'test': 'value'};
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'content-type': 'application/json'},
        body: jsonEncode(testData),
      );
      expect(response.statusCode, equals(200));
      
      final responseData = jsonDecode(response.body);
      expect(responseData['message'], equals('Received JSON data'));
      expect(responseData['data'], equals(testData));
    });
  });
}
