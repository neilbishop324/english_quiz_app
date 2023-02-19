import 'dart:convert';

import 'package:flutter/foundation.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String id;
  final String email;
  final String password;
  final String name;
  final List<String> favorites;
  final String token;
  User(
      {required this.id,
      required this.email,
      required this.password,
      required this.name,
      required this.favorites,
      required this.token});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'favorites': favorites,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      favorites: List<String>.from((map['favorites'] as List<dynamic>)),
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? id,
    String? email,
    String? password,
    String? name,
    List<String>? favorites,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      favorites: favorites ?? this.favorites,
      token: token ?? this.token,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, password: $password, name: $name, favorites: $favorites, token: $token)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.password == password &&
        other.name == name &&
        listEquals(other.favorites, favorites) &&
        other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        password.hashCode ^
        name.hashCode ^
        favorites.hashCode ^
        token.hashCode;
  }
}
