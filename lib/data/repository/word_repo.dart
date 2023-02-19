import 'dart:convert';

import 'package:english_quiz_app/logic/word/bloc/word_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import '../../util/global_variables.dart';
import '../model/word.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class WordRepository {
  Future<Word?> fetchWord(LoadWord loadedWord);
}

class WordRepo extends WordRepository {
  String oxfordApiUri =
      "https://od-api.oxforddictionaries.com:443/api/v2/entries";
  @override
  Future<Word?> fetchWord(LoadWord loadedWord) async {
    try {
      await dotenv.load(fileName: "secret.env");
      String uri = dotenv.env['URI'].toString();
      String oxfordAppId = dotenv.env['OXFORD_APP_ID'].toString();
      String oxfordAppKey = dotenv.env['OXFORD_APP_KEY'].toString();

      final url =
          Uri.parse('$oxfordApiUri/en-gb/${loadedWord.word.toLowerCase()}');
      http.Response response = await http.get(url, headers: {
        'app_id': oxfordAppId,
        'app_key': oxfordAppKey,
      });
      if (response.statusCode == 200) {
        final body = utf8.decode(response.bodyBytes);
        final content = json.decode(body);
        String? tr;
        if (!loadedWord.fromSublist) {
          tr = await getTurkishTranslation(loadedWord.word, uri);
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

  Future<String?> getTurkishTranslation(String word, String uri) async {
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
