import 'dart:convert';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

class JournalService {
  static const String url = 'http://localhost:3000/';
  static const String resource = "learnhttp/";

  String getUrl() => "$url$resource";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  void register(String content) {
    client.post(Uri.parse(getUrl()),
        body: jsonEncode({"content": content}),
        headers: {"Content-Type": "application/json"});
  }

  Future<String> get() async {
    http.Response response = await client.get(Uri.parse(getUrl()));

    return response.body;
  }
}
