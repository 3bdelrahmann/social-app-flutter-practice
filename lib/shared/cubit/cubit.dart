import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/models/comments_model.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/nearby/nearby_screen.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  void getUserData() {
    emit(AppGetUserOnLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
      // print(value.data());
      userModel = UserModel.fromJson(value.data()!);
      emit(AppGetUserOnSuccessState());
    }).catchError((error) {
      emit(AppGetUserOnFailedState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const ChatsScreen(),
    const NearbyScreen(),
    const ProfileScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Nearby',
    'Profile',
  ];

  void changeNavBar(int index) {
    if (index == 1) {
      getAllUsers();
    }
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  var picker = ImagePicker();
  File? profileImage;
  Future<void> pickProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(AppProfileImagePickedOnSuccessState());
    } else {
      print('No image selected.');
      emit(AppProfileImagePickedOnFailedState());
    }
  }

  File? coverImage;
  Future<void> pickCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(AppCoverImagePickedOnSuccessState());
    } else {
      print('No image selected.');
      emit(AppCoverImagePickedOnFailedState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(AppUploadProfileImageOnLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'users/$userId/profiles/${Uri.file(profileImage!.path).pathSegments.last}',
        )
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(AppUploadProfileImageOnSuccessState());

        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          profile: value,
        );
      }).catchError((error) {
        emit(AppUploadProfileImageOnFailedState());
      });
    }).catchError((error) {
      emit(AppUploadProfileImageOnFailedState());
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(AppUploadCoverImageOnLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'users/$userId/covers/${Uri.file(coverImage!.path).pathSegments.last}',
        )
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        // emit(AppUploadCoverImageOnSuccessState());
        updateUser(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(AppUploadCoverImageOnFailedState());
      });
    }).catchError((error) {
      emit(AppUploadCoverImageOnFailedState());
    });
  }

  void updateUser({
    required String name,
    required String phone,
    required String bio,
    String? profile,
    String? cover,
  }) {
    UserModel model = UserModel(
        name: name,
        phone: phone,
        image: profile ?? userModel!.image,
        cover: cover ?? userModel!.cover,
        bio: bio,
        uId: userModel!.uId,
        isEmailVerified: false,
        email: userModel!.email,
        verifiedBadge: userModel!.verifiedBadge);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
      showToast(
        text: 'Saved successfully',
        states: ToastStates.SUCCESS,
      );
      clearImageFile();
    }).catchError((error) {
      emit(AppUpdateUserDataOnFailedState());
    });
  }

  File? postImageFile;
  Future<void> pickPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImageFile = File(pickedFile.path);
      emit(AppPostImagePickedOnSuccessState());
    } else {
      print('No image selected.');
      emit(AppPostImagePickedOnFailedState());
    }
  }

  void uploadPostImage({
    required String postText,
    required String postDateTime,
    String? postImage,
    required BuildContext context,
  }) {
    emit(AppUploadPostImageOnLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child(
          'users/$userId/posts/${Uri.file(postImageFile!.path).pathSegments.last}',
        )
        .putFile(postImageFile!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPostData(
          postText: postText,
          postDateTime: postDateTime,
          postImage: value,
          context: context,
        );
      }).catchError((error) {
        emit(AppUploadPostImageOnFailedState());
      });
    }).catchError((error) {
      emit(AppUploadPostImageOnFailedState());
    });
  }

  void clearImageFile() {
    coverImage = null;
    profileImage = null;
    emit(AppClearImageFilesState());
  }

  void createPostData({
    required String postText,
    required String postDateTime,
    String? postImage,
    required BuildContext context,
  }) {
    emit(AppCreatePostOnLoadingState());
    PostModel model = PostModel(
      postText: postText,
      postImage: postImage ?? ' ',
      postDateTime: postDateTime,
      uId: userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      removePostImage();
      Navigator.pop(context);
      emit(AppCreatePostOnSuccessState());
    }).catchError((error) {
      emit(AppCreatePostOnFailedState());
    });
  }

  void removePostImage() {
    postImageFile = null;
    emit(AppRemovePostImageState());
  }

  List<PostModel> posts = [];
  List<UserModel> postsUsers = [];
  List<String> postsId = [];
  List<int> likesCounter = [];
  List<int> commentsCounter = [];

  void getPostsData() {
    emit(AppGetPostOnLoadingState());

    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('postDateTime')
        .snapshots()
        .listen((event) {
      posts = [];
      postsUsers = [];
      postsId = [];
      likesCounter = [];
      commentsCounter = [];
      event.docs.forEach((element) {
        //get posts users
        FirebaseFirestore.instance
            .collection('users')
            .doc(element.get('uId'))
            .snapshots()
            .listen((postsUsersEvent) {
          //get likes counter
          element.reference
              .collection('likes')
              .snapshots()
              .listen((likesEvent) {
            //get comments counter
            element.reference
                .collection('comments')
                .snapshots()
                .listen((commentsEvent) {
              //get comments data
              commentsCounter.add(commentsEvent.docs.length);
              likesCounter.add(likesEvent.docs.length);
              postsUsers.add(UserModel.fromJson(postsUsersEvent.data()!));
              posts.add(PostModel.fromJson(element.data()));
              postsId.add(element.id);
              emit(AppGetPostOnSuccessState());
            });
          });
        });
      });
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({'like': true}).then((value) {
      emit(AppLikePostOnSuccessState());
    }).catchError((error) {
      emit(AppLikePostOnFailedState(error));
    });
  }

  void commentOnPost(String postId, String text) {
    CommentsModel model = CommentsModel(
      text: text,
      created: Timestamp.fromDate(DateTime.now()),
      uId: userModel!.uId,
      uName: userModel!.name,
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
      emit(AppCommentOnPostOnSuccessState());
    }).catchError((error) {
      emit(AppCommentOnPostOnFailedState(error));
    });
  }

  List<CommentsModel> comments = [];
  void getCommentsData({required String postId}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('created')
        .snapshots()
        .listen((event) {
      comments = [];
      //Get each comment in the doc
      event.docs.forEach((element) {
        comments.add(CommentsModel.fromJson(element.data()));
      });
      emit(AppGetCommentsOnSuccessState());
    });
  }

  List<UserModel> users = [];
  void getAllUsers() {
    emit(AppGetAllUserOnLoadingState());
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel?.uId) {
            users.add(UserModel.fromJson(element.data()));
          }
          emit(AppGetAllUserOnSuccessState());
        });
      }).catchError((error) {
        emit(AppGetAllUserOnFailedState(error.toString()));
      });
    }
  }

  void sendMessage({
    required String receiverId,
    required String text,
  }) {
    MessageModel model = MessageModel(
      receiverId: receiverId,
      senderId: userModel!.uId,
      text: text,
      dateTime: Timestamp.fromDate(DateTime.now()),
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(model.senderId)
        .collection('chats')
        .doc(model.receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(AppSendMessageOnSuccessState());
    }).catchError((error) {
      emit(AppSendMessageOnFailedState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(model.receiverId)
        .collection('chats')
        .doc(model.senderId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(AppSendMessageOnSuccessState());
    }).catchError((error) {
      emit(AppSendMessageOnFailedState());
    });
  }

  List<MessageModel> messages = [];
  void getMessage({
    required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));

        emit(AppGetMessageOnSuccessState());
      });
    });
  }
}
