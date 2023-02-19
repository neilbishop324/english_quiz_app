part of 'sublist_bloc.dart';

@immutable
abstract class SublistState {}

class SublistInitial extends SublistState {}

class SublistLoading extends SublistState {}

class SublistLoaded extends SublistState {
  final List<String> data;

  SublistLoaded(this.data);
}

class SublistError extends SublistState {}
