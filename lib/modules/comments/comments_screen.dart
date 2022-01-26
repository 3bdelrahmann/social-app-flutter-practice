import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';

class CommentsScreen extends StatelessWidget {
  var commentController = TextEditingController();
  final String postId;

  CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Comments'),
        ),
        body: Column(
          children: [
            ConditionalBuilder(
              condition: cubit.comments!.isNotEmpty,
              builder: (context) => Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) => commentsItem(
                    cubit.comments![index],
                    cubit.commentsUsers![index],
                  ),
                  separatorBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                  itemCount: cubit.comments!.length,
                ),
              ),
              fallback: (context) => Expanded(
                child: Center(
                  child: Text(
                    'Write a comment ...',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 1,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 20, end: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Comment ...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  defaultTextButton(
                    onPressed: () {
                      if (commentController.text.trim().isNotEmpty) {
                        cubit.commentOnPost(postId, commentController.text);
                        commentController.clear();
                      } else {
                        showToast(
                            text: 'You can\'t send an empty comment',
                            states: ToastStates.GREY);
                      }
                    },
                    text: 'Send',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commentsItem(CommentsModel commentsModel, UserModel userModel) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 26.0,
            backgroundImage: NetworkImage(userModel.image!),
          ),
          title: Text(userModel.name!),
          subtitle: Text(commentsModel.text!),
        ),
      );
}
