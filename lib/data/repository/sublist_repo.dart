import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import '../../util/constants.dart';

abstract class SublistRepository {
  Future<List<String>?> fetchSublist({required int listId});
  Future<List<String>?> fetchWordsAndPhrases({required int pageNumber});
}

class SublistRepo extends SublistRepository {
  @override
  Future<List<String>?> fetchSublist({required int listId}) async {
    try {
      var sublist = <String>[];
      await dotenv.load(fileName: "secret.env");
      String uri = dotenv.env['URI'].toString();
      http.Response res = await http
          .post(Uri.parse('$uri/sublist/$listId'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (res.statusCode == 200) {
        var jsonData = json.decode(res.body);
        List<Map<String, dynamic>> listData =
            List<Map<String, dynamic>>.from(jsonData);
        for (Map<String, dynamic> data in listData) {
          sublist.add(data["word"]);
        }
      } else {
        log("Resource body: ${res.body}");
        log("Resource status code: ${res.statusCode}");
        return null;
      }
      return sublist;
    } catch (e) {
      log("Error: $e");
      return null;
    }
  }

  @override
  Future<List<String>?> fetchWordsAndPhrases({required int pageNumber}) async {
    try {
      var list = <String>[];
      await dotenv.load(fileName: "secret.env");
      String uri = dotenv.env['URI'].toString();
      http.Response res = await http.post(
        Uri.parse('$uri/word/wap/$pageNumber'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (res.statusCode == 200) {
        var jsonData = json.decode(res.body);
        List<Map<String, dynamic>> listData =
            List<Map<String, dynamic>>.from(jsonData);
        for (Map<String, dynamic> data in listData) {
          list.add(data["en"]);
        }
      } else {
        log("Resource body: ${res.body}");
        log("Resource status code: ${res.statusCode}");
        return null;
      }
      return list;
    } catch (e, stackTrace) {
      log("Error: $e");
      log("Stack Trace: $stackTrace");
      return null;
    }
  }
}
