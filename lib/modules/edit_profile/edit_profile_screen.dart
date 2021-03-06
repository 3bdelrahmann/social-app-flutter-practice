import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var bioController = TextEditingController();
  var phoneController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var userModel = AppCubit.get(context).userModel;
        var profileImage = AppCubit.get(context).profileImage;
        var coverImage = AppCubit.get(context).coverImage;

        nameController.text = userModel!.name!;
        bioController.text = userModel.bio!;
        phoneController.text = userModel.phone!;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            titleSpacing: 5.0,
            actions: [
              defaultTextButton(
                onPressed: () {
                  cubit.updateUser(
                    name: nameController.text,
                    phone: phoneController.text,
                    bio: bioController.text,
                  );
                },
                text: 'save',
              ),
              const SizedBox(
                width: 12.0,
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 190.0,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              if (coverImage == null)
                                Container(
                                  width: double.infinity,
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(userModel.cover!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              if (coverImage != null)
                                Container(
                                  width: double.infinity,
                                  height: 140.0,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                    image: DecorationImage(
                                      image: FileImage(coverImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    cubit.pickCoverImage();
                                  },
                                  child: CircleAvatar(
                                    radius: 25.0,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.5),
                                    child: const Icon(
                                      IconBroken.Camera,
                                      color: Colors.white,
                                      size: 25.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            if (profileImage == null)
                              CircleAvatar(
                                radius: 61,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage:
                                      NetworkImage(userModel.image!),
                                ),
                              ),
                            if (profileImage != null)
                              CircleAvatar(
                                radius: 61,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: FileImage(profileImage),
                                ),
                              ),
                            InkWell(
                              onTap: () {
                                cubit.pickProfileImage();
                              },
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundColor: Colors.black.withOpacity(0.5),
                                child: const Icon(
                                  IconBroken.Camera,
                                  color: Colors.white,
                                  size: 25.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (profileImage != null || coverImage != null)
                    Row(
                      children: [
                        if (profileImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  text: 'Upload profile',
                                  onPressed: () {
                                    cubit.uploadProfileImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                    );
                                  },
                                  radius: 0.0,
                                  height: 40.0,
                                ),
                                if (state ==
                                    AppUploadProfileImageOnLoadingState())
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if (coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                defaultButton(
                                  text: 'Upload cover',
                                  onPressed: () {
                                    cubit.uploadCoverImage(
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      bio: bioController.text,
                                    );
                                  },
                                  radius: 0.0,
                                  height: 40.0,
                                ),
                                if (state ==
                                    AppUploadCoverImageOnLoadingState())
                                  const LinearProgressIndicator(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            validate: (name) {
                              if (name!.isEmpty) {
                                return 'Name must not be empty';
                              }
                            },
                            prefix: IconBroken.User,
                            label: 'Name',
                            radius: 0.0,
                            filled: false),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: bioController,
                            type: TextInputType.text,
                            validate: (bio) {
                              if (bio!.isEmpty) {
                                return 'Bio must not be empty';
                              }
                            },
                            prefix: IconBroken.Paper,
                            label: 'Bio',
                            radius: 0.0,
                            filled: false),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                            controller: phoneController,
                            type: TextInputType.number,
                            validate: (phone) {
                              if (phone!.isEmpty) {
                                return 'Phone must not be empty';
                              }
                            },
                            prefix: IconBroken.Call,
                            label: 'Phone',
                            radius: 0.0,
                            filled: false),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
