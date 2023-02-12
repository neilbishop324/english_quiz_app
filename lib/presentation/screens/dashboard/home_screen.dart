import 'dart:math';

import 'package:english_quiz_app/logic/home/cubit/home_cubit.dart';
import 'package:english_quiz_app/logic/user/cubit/user_cubit.dart';
import 'package:english_quiz_app/presentation/screens/dashboard/components/home_component.dart';
import 'package:english_quiz_app/presentation/screens/dashboard/components/profile_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:random_avatar/random_avatar.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const List<Widget> _widgetOptions = <Widget>[
    HomeComponent(),
    Text(
      'Index 1: Collection',
    ),
    ProfileComponent(),
  ];

  static final _selectedItemColor = Colors.amber[800];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Home Page"),
          ),
          body: _widgetOptions.elementAt(state.selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavBarItems(context),
            currentIndex: state.selectedIndex,
            selectedItemColor: _selectedItemColor,
            onTap: (index) => _onItemTapped(index, context),
          ),
        );
      },
    );
  }

  List<BottomNavigationBarItem> bottomNavBarItems(BuildContext context) {
    return <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        activeIcon: Image.asset(
          "assets/images/vocabulary.png",
          width: 27,
          height: 27,
          color: _selectedItemColor,
        ),
        icon: Image.asset("assets/images/vocabulary.png",
            width: 27, height: 27, color: const Color(0xff424150)),
        label: 'Collection',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.account_box),
        label: 'Account',
      ),
    ];
  }

  void _onItemTapped(int index, BuildContext context) {
    context.read<HomeCubit>().setSelectedIndex(index);
  }
}
