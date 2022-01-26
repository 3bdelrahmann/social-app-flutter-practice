import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';

class CommentsScreen extends StatelessWidget {
  var commentController = TextEditingController();
  final String postId;

  CommentsScreen({required this.postId});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return Builder(builder: (BuildContext context) {
      cubit.getCommentsData(postId: postId);

      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Comments'),
          ),
          body: Column(
            children: [
              ConditionalBuilder(
                condition: cubit.comments.isNotEmpty,
                builder: (context) => Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        commentsItem(cubit.comments[index]),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 10.0),
                    itemCount: cubit.comments.length,
                  ),
                ),
                fallback: (context) => const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: TextFormField(
                          controller: commentController,
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: 'Comment ...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    MaterialButton(
                      height: 50.0,
                      minWidth: 1.0,
                      color: kMainColor,
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
                      child: Text(
                        'Send'.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget commentsItem(CommentsModel commentsModel) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CircleAvatar(
            //   radius: 18.0,
            //   backgroundImage: NetworkImage(''),
            // ),
            // SizedBox(
            //   width: 5.0,
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          commentsModel.uName!,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          commentsModel.text!,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  DateFormat.yMMMd('en_US')
                      .add_jm()
                      .format(commentsModel.created!.toDate())
                      .toString(),
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ],
        ),
      );
}
