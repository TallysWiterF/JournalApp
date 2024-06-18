import 'dart:convert';

import 'package:http/http.dart' as http;

class JournalService {
  static const String url = 'http://localhost:3000/';
  static const String resource = "learnhttp/";

  String getUrl() => "$url$resource";

  void register(String content) {
    http.post(Uri.parse(getUrl()),
        body: jsonEncode({"content": content}),
        headers: {"Content-Type": "application/json"});
  }

  Future<String> get() async {
    http.Response response = await http.get(Uri.parse(getUrl()));

    return response.body;
  }
}
