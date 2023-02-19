// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SublistWord {
  final String word;
  SublistWord({
    required this.word,
  });

  SublistWord copyWith({
    String? word,
  }) {
    return SublistWord(
      word: word ?? this.word,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'word': word,
    };
  }

  factory SublistWord.fromMap(Map<String, dynamic> map) {
    return SublistWord(
      word: map['word'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SublistWord.fromJson(String source) =>
      SublistWord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SublistWord(word: $word)';

  @override
  bool operator ==(covariant SublistWord other) {
    if (identical(this, other)) return true;

    return other.word == word;
  }

  @override
  int get hashCode => word.hashCode;
}
