import 'dart:convert';
import 'dart:io';

import 'package:english_quiz_app/logic/user/cubit/user_cubit.dart';
import 'package:english_quiz_app/util/error_handling.dart';
import 'package:english_quiz_app/util/constants.dart';
import 'package:english_quiz_app/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
      await dotenv.load(fileName: "secret.env");
      String uri = dotenv.env['URI'].toString();

      User user = User(
          id: "",
          email: email,
          password: password,
          name: name,
          favorites: List.empty(),
          token: "");
      http.Response res = await http.post(Uri.parse('$uri/auth/signup'),
          body: user.toJson(),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            snackBar(context,
                title: "Account created! Login with the same credentials");
          },
        );
      }
    } catch (e) {
      snackBar(context, title: e.toString());
    }
  }

  void signInUser(
      {required BuildContext context,
      required String email,
      required String password,
      required VoidCallback onSignedIn}) async {
    try {
      await dotenv.load(fileName: "secret.env");
      String uri = dotenv.env['URI'].toString();

      http.Response res = await http.post(Uri.parse('$uri/auth/signin'),
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (context.mounted) {
        httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            if (context.mounted) {
              context.read<UserCubit>().setUser(res.body);
            }
            await prefs.setString(
                'x-auth-token', jsonDecode(res.body)['token']);
            onSignedIn();
          },
        );
      }
    } catch (e) {
      snackBar(context, title: e.toString());
    }
  }

  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("x-auth-token");

      if (token == null) {
        prefs.setString("x-auth-token", "");
      }

      await dotenv.load(fileName: "secret.env");
      String uri = dotenv.env['URI'].toString();

      var tokenRes = await http.post(Uri.parse("$uri/auth/tokenIsValid"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "x-auth-token": token!
          });

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse("$uri/auth/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "x-auth-token": token
          },
        );

        var user = userRes.body;
        if (context.mounted) {
          context.read<UserCubit>().setUser(user);
        }
      }
    } catch (e, stackTrace) {
      log("Error: $e");
      log("Stack Trace: $stackTrace");
    }
  }
}
