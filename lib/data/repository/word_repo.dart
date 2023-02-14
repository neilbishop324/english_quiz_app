import 'dart:convert';

import 'package:english_quiz_app/logic/word/bloc/word_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import '../../util/global_variables.dart';
import '../model/word.dart';

abstract class WordRepository {
  Future<Word?> fetchWord(LoadWord LoadWord);
}

class WordRepo extends WordRepository {
  String oxfordAppId = "2b0a920d";
  String oxfordAppKey = "a808a5b180a12a330c91e0f6112ce3a3";

  @override
  Future<Word?> fetchWord(LoadWord LoadWord) async {
    try {
      final url =
          Uri.parse('$oxfordApiUri/en-gb/${LoadWord.word.toLowerCase()}');
      http.Response response = await http.get(url, headers: {
        'app_id': oxfordAppId,
        'app_key': oxfordAppKey,
      });
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final content = json.decode(body);
        String? tr;
        if (!LoadWord.fromSublist) {
          tr = await getTurkishTranslation(LoadWord.word);
        }
        return Word.fromMap(content, tr);
      } else {
        log('Request failed with status: ${response.statusCode}.');
      }
    } catch (e, stackTrace) {
      log("Error: $e");
      log("Stack Trace: $stackTrace");
    }
    return null;
  }

  Future<String?> getTurkishTranslation(String word) async {
    try {
      final url = "$uri/word/$word";
      http.Response response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      });
      if (response.statusCode == 200) {
        final content = json.decode(response.body);
        if (content.length > 0) {
          return content[0]["tr"];
        }
      } else {
        log('Translation request failed with status: ${response.statusCode}.');
      }
    } catch (e, stackTrace) {
      log("Error: $e");
      log("Stack Trace: $stackTrace");
    }
    return null;
  }
}
