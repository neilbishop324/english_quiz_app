import 'dart:convert';
import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Word {
  String en;
  String? tr;
  List<String> etymologies;
  Pronunciation? pronunciation;
  List<Sense> senses;
  String? wordType;
  Word({
    required this.en,
    this.tr,
    required this.etymologies,
    this.pronunciation,
    required this.senses,
    this.wordType,
  });

  Word copyWith({
    String? en,
    String? tr,
    List<String>? etymologies,
    Pronunciation? pronunciation,
    List<Sense>? senses,
    String? wordType,
  }) {
    return Word(
      en: en ?? this.en,
      tr: tr ?? this.tr,
      etymologies: etymologies ?? this.etymologies,
      pronunciation: pronunciation ?? this.pronunciation,
      senses: senses ?? this.senses,
      wordType: wordType ?? this.wordType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'en': en,
      'tr': tr,
      'etymologies': etymologies,
      'pronunciation': (pronunciation == null) ? null : pronunciation!.toMap(),
      'senses': senses.map((x) => x.toMap()).toList(),
      'wordType': wordType,
    };
  }

  factory Word.fromMap(Map<String, dynamic> map, String? tr) {
    List<Sense> senses = map['results'][0]['lexicalEntries']
        .map((lexicalEntries) => lexicalEntries['entries'])
        .expand((lexicalEntries) => lexicalEntries as Iterable<dynamic>)
        .map((entries) => entries['senses'])
        .expand((entries) => entries as Iterable<dynamic>)
        .map<Sense>((sense) => Sense.fromMap(sense))
        .toList();

    List<String> etymologies =
        ((map['results'][0]['lexicalEntries'] as List<dynamic>?) ?? [])
            .map((entry) => entry['entries'] as List<dynamic>)
            .expand((entries) => entries)
            .map((entry) => entry['etymologies'] as List<dynamic>?)
            .expand((etymologies) => etymologies ?? [])
            .map((etymology) => etymology as String)
            .toList();

    Pronunciation? pronunciation = Pronunciation.fromMap(map['results'][0]
            ['lexicalEntries']
        .map((entry) => entry['entries'])
        .expand((entries) => entries as Iterable<dynamic>)
        .map((entry) => entry['pronunciations'])
        .expand((pronunciations) => pronunciations as Iterable<dynamic>)
        .toList()[0] as Map<String, dynamic>);

    return Word(
      en: map['word'] as String,
      tr: tr,
      etymologies: etymologies,
      pronunciation: pronunciation,
      senses: senses,
      wordType: map['results'][0]['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Word.fromJson(String source) =>
      Word.fromMap(json.decode(source) as Map<String, dynamic>, null);

  @override
  String toString() {
    return 'Word(en: $en, tr: $tr, etymologies: $etymologies, pronunciation: $pronunciation, senses: $senses, wordType: $wordType)';
  }

  @override
  bool operator ==(covariant Word other) {
    if (identical(this, other)) return true;

    return other.en == en &&
        other.tr == tr &&
        listEquals(other.etymologies, etymologies) &&
        other.pronunciation == pronunciation &&
        listEquals(other.senses, senses) &&
        other.wordType == wordType;
  }

  @override
  int get hashCode {
    return en.hashCode ^
        tr.hashCode ^
        etymologies.hashCode ^
        pronunciation.hashCode ^
        senses.hashCode ^
        wordType.hashCode;
  }
}

class Pronunciation {
  String? audioFile;
  List<String> dialects;
  String? phoneticNotation;
  String? phoneticSpelling;
  Pronunciation({
    this.audioFile,
    required this.dialects,
    this.phoneticNotation,
    this.phoneticSpelling,
  });

  Pronunciation copyWith({
    String? audioFile,
    List<String>? dialects,
    String? phoneticNotation,
    String? phoneticSpelling,
  }) {
    return Pronunciation(
      audioFile: audioFile ?? this.audioFile,
      dialects: dialects ?? this.dialects,
      phoneticNotation: phoneticNotation ?? this.phoneticNotation,
      phoneticSpelling: phoneticSpelling ?? this.phoneticSpelling,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'audioFile': audioFile,
      'dialects': dialects,
      'phoneticNotation': phoneticNotation,
      'phoneticSpelling': phoneticSpelling,
    };
  }

  factory Pronunciation.fromMap(Map<String, dynamic> map) {
    return Pronunciation(
      audioFile: map['audioFile'] != null ? map['audioFile'] as String : null,
      dialects: (map['dialects'] as List<dynamic>)
          .map((dialect) => dialect.toString())
          .toList(),
      phoneticNotation: map['phoneticNotation'] != null
          ? map['phoneticNotation'] as String
          : null,
      phoneticSpelling: map['phoneticSpelling'] != null
          ? map['phoneticSpelling'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Pronunciation.fromJson(String source) =>
      Pronunciation.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Pronunciation(audioFile: $audioFile, dialects: $dialects, phoneticNotation: $phoneticNotation, phoneticSpelling: $phoneticSpelling)';
  }

  @override
  bool operator ==(covariant Pronunciation other) {
    if (identical(this, other)) return true;

    return other.audioFile == audioFile &&
        listEquals(other.dialects, dialects) &&
        other.phoneticNotation == phoneticNotation &&
        other.phoneticSpelling == phoneticSpelling;
  }

  @override
  int get hashCode {
    return audioFile.hashCode ^
        dialects.hashCode ^
        phoneticNotation.hashCode ^
        phoneticSpelling.hashCode;
  }
}

class Sense {
  List<String> definitions;
  List<String> shortDefinitions;
  List<String> examples;
  List<String> types; //domain classes
  Sense({
    required this.definitions,
    required this.shortDefinitions,
    required this.examples,
    required this.types,
  });

  Sense copyWith({
    List<String>? definitions,
    List<String>? shortDefinitions,
    List<String>? examples,
    List<String>? types,
  }) {
    return Sense(
      definitions: definitions ?? this.definitions,
      shortDefinitions: shortDefinitions ?? this.shortDefinitions,
      examples: examples ?? this.examples,
      types: types ?? this.types,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'definitions': definitions,
      'shortDefinitions': shortDefinitions,
      'examples': examples,
      'types': types,
    };
  }

  factory Sense.fromMap(Map<String, dynamic> map) {
    List<String> domainClasses = [];
    try {
      domainClasses = ((map['domainClasses'] as List<dynamic>?) ?? [])
          .map((domainClass) => domainClass["type"])
          .expand((map) => map as Iterable<String>)
          .toList();
    } catch (e) {
      domainClasses = [];
    }

    return Sense(
      definitions: ((map['definitions'] as List<dynamic>?) ?? [])
          .map((value) => value.toString())
          .toList(),
      shortDefinitions: ((map['shortDefinitions'] as List<dynamic>?) ?? [])
          .map((value) => value.toString())
          .toList(),
      examples: ((map['examples'] as List<dynamic>?) ?? [])
          .map((value) => value.toString())
          .toList(),
      types: domainClasses,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sense.fromJson(String source) =>
      Sense.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Sense(definitions: $definitions, shortDefinitions: $shortDefinitions, examples: $examples, types: $types)';
  }

  @override
  bool operator ==(covariant Sense other) {
    if (identical(this, other)) return true;

    return listEquals(other.definitions, definitions) &&
        listEquals(other.shortDefinitions, shortDefinitions) &&
        listEquals(other.examples, examples) &&
        listEquals(other.types, types);
  }

  @override
  int get hashCode {
    return definitions.hashCode ^
        shortDefinitions.hashCode ^
        examples.hashCode ^
        types.hashCode;
  }
}
