import 'package:bloc/bloc.dart';
import 'package:english_quiz_app/data/model/user.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit()
      : super(UserState(
            user: User(
                id: "",
                email: "",
                password: "",
                name: "",
                favorites: List.empty(),
                token: "")));

  void setUser(String user) => emit(UserState(user: User.fromJson(user)));
  User get user => state.user;
}
