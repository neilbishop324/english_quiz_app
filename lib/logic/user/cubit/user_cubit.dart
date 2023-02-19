import 'package:english_quiz_app/data/model/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
