import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(selectedIndex: 0));

  void setSelectedIndex(int index) => emit(HomeState(selectedIndex: index));
}