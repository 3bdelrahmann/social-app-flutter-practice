import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class AddPostScreen extends StatelessWidget {
  var postController = TextEditingController();
  String todayDate =
      DateFormat.yMMMMd('en_US').add_jm().format(DateTime.now()).toString();
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Create a post'),
              actions: [
                defaultTextButton(
                  onPressed: () {
                    if (cubit.postImageFile == null) {
                      cubit.createPostData(
                        postText: postController.text,
                        postDateTime: todayDate,
                        context: context,
                      );
                    } else {
                      if (postController.text == '') {
                        Navigator.pop(context);
                      } else {
                        cubit.uploadPostImage(
                          postText: postController.text,
                          postDateTime: todayDate,
                          context: context,
                        );
                      }
                    }
                  },
                  text: 'post',
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                height: 600.0,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                              NetworkImage(cubit.userModel!.image!),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  cubit.userModel!.name!,
                                  style: TextStyle(
                                    height: 1.4,
                                  ),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                if (cubit.userModel!.verifiedBadge!)
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.blue,
                                    size: 16.0,
                                  ),
                              ],
                            ),
                            Text(
                              'public',
                              style:
                                  Theme.of(context).textTheme.caption?.copyWith(
                                        height: 1.4,
                                      ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: postController,
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            hintText: 'What\'s in your mind?',
                            border: InputBorder.none),
                      ),
                    ),
                    if (cubit.postImageFile != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 200.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                image: DecorationImage(
                                  image: FileImage(cubit.postImageFile!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  cubit.removePostImage();
                                },
                                child: CircleAvatar(
                                  radius: 25.0,
                                  backgroundColor:
                                      Colors.black.withOpacity(0.5),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 25.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              cubit.pickPostImage();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(IconBroken.Image),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text('Add a photo'),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.tag),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text('Tags'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
