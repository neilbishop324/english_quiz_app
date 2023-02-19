import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import '../logic/user/cubit/user_cubit.dart';
import '../presentation/screens/authentication/auth_screen.dart';

class AccountService {
  Future<bool> isInFavorites(String word) async {
    try {
      await dotenv.load(fileName: "secret.env");
      String uri = dotenv.env['URI'].toString();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("x-auth-token") ?? "";

      http.Response res = await http.post(
          Uri.parse('$uri/user/isInFavorites/$word'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          });

      if (res.statusCode == 200) {
        var jsonData = json.decode(res.body);
        return jsonData["isInFavorites"];
      }
    } catch (e) {
      log(e);
    }
    return false;
  }

  Future<bool> updateFavorites({
    required bool shouldAdd,
    required String word,
    required BuildContext context,
  }) async {
    try {
      await dotenv.load(fileName: "secret.env");
      String uri = dotenv.env['URI'].toString();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("x-auth-token") ?? "";

      http.Response res = await http.post(
        Uri.parse('$uri/user/favorites'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
          'add-word': shouldAdd.toString(),
        },
        body: jsonEncode({'word': word}),
      );

      if (res.statusCode == 200) {
        var user = res.body;
        if (context.mounted) {
          context.read<UserCubit>().setUser(user);
        }
        return true;
      }
    } catch (e) {
      log(e);
    }
    return false;
  }

  void logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString('x-auth-token', '');
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          AuthScreen.routeName,
          (route) => false,
        );
      }
    } catch (e) {
      snackBar(context, title: e.toString());
    }
  }
}
