import 'dart:convert';

import 'package:english_quiz_app/util/error_handling.dart';
import 'package:english_quiz_app/util/global_variables.dart';
import 'package:english_quiz_app/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/user.dart';
import 'package:http/http.dart' as http;

class AuthService {
  void signUpUser(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    try {
      print("print 1");
      User user = User(id: "", email: email, password: password, name: name);
      http.Response res = await http.post(Uri.parse('$uri/api/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      print("print 2");

      if (context.mounted) {
        print("print 3");
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            print("print 4");
            snackBar(context,
                title: "Account created! Login with the same credentials");
          },
        );
        print("print 5");
      }
    } catch (e) {
      print("print 6: $e");
      snackBar(context, title: e.toString());
    }
  }

  void signInUser(
      {required BuildContext context,
      required String email,
      required String password,
      required VoidCallback onSignedIn}) async {
    try {
      print("task 1");
      http.Response res = await http.post(Uri.parse('$uri/api/signin'),
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      print("task 2");

      if (context.mounted) {
        print("task 3");
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            print("task 4");
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);
            print("task 5");
            onSignedIn();
          },
        );
        print("task 6");
      }
    } catch (e) {
      print("task 7: $e");
      snackBar(context, title: e.toString());
    }
  }
}
