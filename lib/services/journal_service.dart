import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/webclient.dart';
import 'package:http/http.dart' as http;

class JournalService {
  static const String url = WebClient.url;
  http.Client client = WebClient().client;

  static const String resource = "journals/";

  String getUrl() => "$url$resource";

  Future<bool> register(Journal journal, String token) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(Uri.parse(getUrl()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonJournal);

    return validateStatusCode(response, HttpStatus.created);
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    journal.updatedAt = DateTime.now();

    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.put(Uri.parse(getUrl() + id),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonJournal);

    return validateStatusCode(response, HttpStatus.ok);
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await client.delete(Uri.parse(getUrl() + id),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        });

    return validateStatusCode(response, HttpStatus.ok);
  }

  Future<List<Journal>> getAll({required int id, required String token}) async {
    http.Response response = await client.get(
        Uri.parse("${url}users/$id/journals"),
        headers: {"Authorization": "Bearer $token"});

    validateStatusCode(response, HttpStatus.ok);

    List<Journal> listJournal = [];
    List<dynamic> listDynamic = jsonDecode(response.body);

    for (var jsonMap in listDynamic) {
      listJournal.add(Journal.fromMap(jsonMap));
    }

    return listJournal;
  }

  bool validateStatusCode(http.Response response, int statusCode) {
    if (response.statusCode != statusCode) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }

      throw HttpException(response.body);
    }

    return true;
  }
}

class TokenNotValidException implements Exception {}
