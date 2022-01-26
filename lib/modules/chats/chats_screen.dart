import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats_details/chats_details_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => commentsBuilder(cubit.users, context));
  }

  Widget commentsBuilder(List<UserModel> userModel, BuildContext context) =>
      ListView.separated(
          itemBuilder: (context, index) =>
              commentsItem(userModel[index], context),
          separatorBuilder: (context, index) => Container(
                height: 1,
                color: Colors.grey[300],
              ),
          itemCount: AppCubit.get(context).users.length);
  Widget commentsItem(UserModel userModel, BuildContext context) => InkWell(
        onTap: () {
          navigateTo(
              context: context,
              newRoute: ChatDetailsScreen(userModel: userModel),
              backRoute: true);
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(20.0),
          leading: CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(userModel.image!),
          ),
          title: Text(userModel.name!),
        ),
      );
}
