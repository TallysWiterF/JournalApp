import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

class AuthService {
  //TODO: Modularizar endpoint
  //Alterar localhost pelo ip
  static const String url = 'http://localhost:3000/';

  static String _resource = "login/";

  String getUrl() => "$url$_resource";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  Future<bool> login({required String email, required String password}) async {
    _resource = "login/";

    http.Response response = await client.post(Uri.parse(getUrl()),
        body: {'email': email, 'password': password});

    if (response.statusCode != 200) {
      String content = json.decode(response.body);

      switch (content) {
        case "Cannot find user":
          throw UserNotFindException();
      }

      throw HttpException(response.body);
    }

    return true;
  }

  register({required String email, required String password}) async {
    _resource = "register/";

    http.Response response = await client.post(Uri.parse(getUrl()),
        body: {'email': email, 'password': password});

    if (response.statusCode != 200) {
      String content = json.decode(response.body);

      switch (content) {
        case "Cannot find user":
          throw UserNotFindException();
      }

      throw HttpException(response.body);
    }

    return response.statusCode == 200;
  }
}

class UserNotFindException implements Exception {}
