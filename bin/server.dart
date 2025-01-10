import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'dart:convert';

void main() async {
  // Create handler
  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_handleRequest);

  // Serve handler
  var server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Server running on localhost:${server.port}');
}

Future<Response> _handleRequest(Request request) async {
  switch (request.method) {
    case 'GET':
      return _handleGetRequest(request);
    case 'POST':
      if (request.headers['content-type']?.contains('application/json') ?? false) {
        return _handleJsonRequest(request);
      }
      return Response(400, body: 'Invalid content type');
    default:
      return Response(405, body: 'Method not allowed');
  }
}

Response _handleGetRequest(Request request) {
  switch (request.url.path) {
    case '':
    case '/':
      return Response.ok('Hello, Dart API!');
    case 'health':
      return Response.ok('OK');
    default:
      return Response.notFound('Not Found');
  }
}

Future<Response> _handleJsonRequest(Request request) async {
  try {
    final requestBody = await request.readAsString();
    final requestData = jsonDecode(requestBody);
    final responseData = {
      'message': 'Received JSON data',
      'data': requestData
    };
    return Response.ok(
      jsonEncode(responseData),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    return Response(400, body: 'Invalid JSON');
  }
}