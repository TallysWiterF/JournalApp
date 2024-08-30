import 'dart:convert';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

class JournalService {
  //Alterar localhost pelo ip
  static const String url = 'http://localhost:3000/';

  static const String resource = "journals/";

  String getUrl() => "$url$resource";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  Future<bool> register(Journal journal, String token) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(Uri.parse(getUrl()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonJournal);

    return response.statusCode == 201;
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.put(Uri.parse(getUrl() + id),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonJournal);

    return response.statusCode == 200;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await client.delete(Uri.parse(getUrl() + id),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        });

    return response.statusCode == 200;
  }

  Future<List<Journal>> getAll({required int id, required String token}) async {
    http.Response response = await client.get(
        Uri.parse("${url}users/$id/journals"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode != 200) throw Exception();

    List<Journal> listJournal = [];
    List<dynamic> listDynamic = jsonDecode(response.body);

    for (var jsonMap in listDynamic) {
      listJournal.add(Journal.fromMap(jsonMap));
    }

    return listJournal;
  }
}
