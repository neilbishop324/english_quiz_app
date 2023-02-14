// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SublistWord {
  final String word;
  final int listId;
  SublistWord({
    required this.word,
    required this.listId,
  });

  SublistWord copyWith({
    String? word,
    int? listId,
  }) {
    return SublistWord(
      word: word ?? this.word,
      listId: listId ?? this.listId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'word': word,
      'listId': listId,
    };
  }

  factory SublistWord.fromMap(Map<String, dynamic> map) {
    return SublistWord(
      word: map['word'] as String,
      listId: map['listId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory SublistWord.fromJson(String source) =>
      SublistWord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SublistWord(word: $word, listId: $listId)';

  @override
  bool operator ==(covariant SublistWord other) {
    if (identical(this, other)) return true;

    return other.word == word && other.listId == listId;
  }

  @override
  int get hashCode => word.hashCode ^ listId.hashCode;
}
