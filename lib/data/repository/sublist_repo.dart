import 'dart:convert';
import 'package:english_quiz_app/data/model/sublist_word.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import '../../util/global_variables.dart';

abstract class SublistRepository {
  Future<List<SublistWord>?> fetchSublist({required int listId});
}

class SublistRepo extends SublistRepository {
  @override
  Future<List<SublistWord>?> fetchSublist({required int listId}) async {
    try {
      var sublist = <SublistWord>[];
      http.Response res = await http
          .post(Uri.parse('$uri/sublist/$listId'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      if (res.statusCode == 200) {
        var jsonData = json.decode(res.body);
        List<Map<String, dynamic>> listData =
            List<Map<String, dynamic>>.from(jsonData);
        for (Map<String, dynamic> data in listData) {
          sublist.add(SublistWord(word: data["word"], listId: listId));
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
}
