import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/add_post/addPostScreen.dart';
import 'package:social_app/modules/comments/comments_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) => ConditionalBuilder(
        condition: cubit.posts.length > 0 && cubit.postsUsers.length > 0,
        builder: (context) => SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Card(
                elevation: 5.0,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24.0,
                        backgroundImage: NetworkImage(cubit.userModel!.image!),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            navigateTo(
                              context: context,
                              newRoute: AddPostScreen(),
                              backRoute: true,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Colors.grey[200],
                            ),
                            child: Text(
                              'What\'s in your mind?',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  ?.copyWith(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => buildPostsItem(
                      context: context,
                      postModel: cubit.posts[index],
                      postsUsersModel: cubit.postsUsers[index],
                      postId: cubit.postsId[index],
                      index: index),
                  separatorBuilder: (context, index) => SizedBox(
                        height: 8.0,
                      ),
                  itemCount: cubit.posts.length),
              SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
        fallback: (context) => Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget buildPostsItem({
    required BuildContext context,
    required PostModel postModel,
    required UserModel postsUsersModel,
    required String postId,
    required index,
  }) =>
      Card(
        elevation: 5.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(postsUsersModel.image!),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              postsUsersModel.name!,
                              style: TextStyle(
                                height: 1.4,
                              ),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            if (postsUsersModel.verifiedBadge!)
                              Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                                size: 16.0,
                              ),
                          ],
                        ),
                        Text(
                          '${postModel.postDateTime}',
                          style: Theme.of(context).textTheme.caption?.copyWith(
                                height: 1.4,
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {},
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Container(
                  height: 1.0,
                  color: Colors.grey[300],
                ),
              ),
              Text(
                '${postModel.postText}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                  top: 5.0,
                ),
                // child: Container(
                //   width: double.infinity,
                //   child: Wrap(
                //     children: [
                //       Padding(
                //         padding: const EdgeInsetsDirectional.only(
                //           end: 6.0,
                //         ),
                //         child: InkWell(
                //           onTap: () {},
                //           child: Text(
                //             '#Valorent',
                //             style:
                //                 Theme.of(context).textTheme.subtitle1?.copyWith(
                //                       color: Colors.blue,
                //                     ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ),
              if (postModel.postImage != ' ')
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Container(
                    width: double.infinity,
                    height: 140.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          '${postModel.postImage}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          children: [
                            Icon(
                              IconBroken.Heart,
                              color: Colors.red,
                              size: 16.0,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text(
                              '${AppCubit.get(context).likesCounter[index]}',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {},
                    ),
                    Spacer(),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          '${AppCubit.get(context).commentsCounter[index]} comments',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Container(
                height: 1.0,
                color: Colors.grey[300],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        AppCubit.get(context).likePost(postId);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.grey[800],
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Like',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        AppCubit.get(context).getCommentsData(postId);
                        navigateTo(
                          context: context,
                          newRoute: CommentsScreen(
                            postId: postId,
                          ),
                          backRoute: true,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.comment,
                            color: Colors.grey[800],
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Comment',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
