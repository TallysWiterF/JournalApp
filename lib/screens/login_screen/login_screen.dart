import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/commom/confirmate_dialog.dart';
import 'package:flutter_webapi_first_course/screens/commom/exception_dialog.dart';
import 'package:flutter_webapi_first_course/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(32),
        decoration:
            BoxDecoration(border: Border.all(width: 8), color: Colors.white),
        child: Form(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.bookmark,
                    size: 64,
                    color: Colors.brown,
                  ),
                  const Text(
                    "Simple Journal",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Divider(thickness: 2),
                  ),
                  const Text("Entre ou Registre-se"),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("E-mail"),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(label: Text("Senha")),
                    keyboardType: TextInputType.visiblePassword,
                    maxLength: 16,
                    obscureText: true,
                    controller: _passController,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        login(context);
                      },
                      child: const Text("Continuar")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  login(BuildContext context) {
    authService
        .login(email: _emailController.text, password: _passController.text)
        .then(
      (resultLogin) {
        if (resultLogin) navigateToHomeScreen(context);
      },
    ).catchError(
      (error) {
        showExceptionDialog(context, content: error.message);
      },
      test: (error) => error is HttpException,
    ).catchError(
      (error) {
        showConfirmationDialog(context,
                content:
                    "Esse usuário não está cadastrado! Deseja realizar o cadastro?",
                affirmativeOption: "Criar")
            .then((value) => {
                  if (value)
                    authService
                        .register(
                            email: _emailController.text,
                            password: _passController.text)
                        .then((resultRegister) {
                      if (resultRegister) navigateToHomeScreen(context);
                    })
                });
      },
      test: (error) => error is UserNotFindException,
    ).catchError((error) {
      showExceptionDialog(context,
          content:
              "O servidor demorou para responder, tente novamente mais tarde.");
    }, test: (error) => error is TimeoutException);
  }

  void navigateToHomeScreen(BuildContext context) {
    Navigator.pushReplacementNamed(context, "home");
  }
}
