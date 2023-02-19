import 'package:english_quiz_app/logic/user/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/sublist/bloc/sublist_bloc.dart';
import '../../../util/utils.dart';
import '../../error/components/error_component.dart';

class CollectionComponent extends StatefulWidget {
  const CollectionComponent({super.key});

  @override
  State<CollectionComponent> createState() => _CollectionComponentState();
}

class _CollectionComponentState extends State<CollectionComponent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return wordListWidget(state.user.favorites, true, context);
      },
    );
  }
}
