import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/services/webclient.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String url = WebClient.url;
  http.Client client = WebClient().client;

  static String _resource = "";

  String getUrl() => "$url$_resource";

  Future<bool> login({required String email, required String password}) async {
    _resource = "login/";

    http.Response response = await client.post(Uri.parse(getUrl()),
        body: {'email': email, 'password': password});

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "Cannot find user") {
        throw UserNotFindException();
      }

      throw HttpException(response.body);
    }

    saveUserInfos(jsonDecode(response.body));
    return true;
  }

  Future<bool> register(
      {required String email, required String password}) async {
    _resource = "register/";

    http.Response response = await client.post(Uri.parse(getUrl()),
        body: {'email': email, 'password': password});

    if (response.statusCode != 201) throw HttpException(response.body);

    saveUserInfos(jsonDecode(response.body));

    return true;
  }

  saveUserInfos(Map<String, dynamic> map) async {
    String token = map["accessToken"];
    String email = map["user"]["email"];
    int id = map["user"]["id"];

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("accessToken", token);
    sharedPreferences.setString("email", email);
    sharedPreferences.setInt("id", id);
  }
}

class UserNotFindException implements Exception {}
