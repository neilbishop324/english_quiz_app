import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:random_avatar/random_avatar.dart';

import '../../../../logic/user/cubit/user_cubit.dart';

class ProfileComponent extends StatefulWidget {
  const ProfileComponent({super.key});

  @override
  State<ProfileComponent> createState() => _ProfileComponentState();
}

class _ProfileComponentState extends State<ProfileComponent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RandomAvatar(state.user.id,
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.width / 3),
              ).paddingAll(20),
            ),
            Text(
              state.user.name,
              style: const TextStyle(fontSize: 18),
            )
          ],
        );
      },
    );
  }
}
