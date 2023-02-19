// ignore_for_file: public_member_api_docs, sort_constructors_first
class Question {
  String word;
  Option option1;
  Option option2;
  Option option3;
  Option option4;
  Question({
    required this.word,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
  });
}

class Option {
  String word;
  String title;
  int index;
  bool isTrue;
  Option({
    required this.word,
    required this.title,
    required this.index,
    required this.isTrue,
  });
}
