import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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
import 'package:social_app/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;
  void getUserData() {
    emit(AppGetUserOnLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData(key: 'userId'))
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
    if (index == 2) {
      getLocation();
      getAllUsersLocations();
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
      showToast(text: 'No image selected.', states: ToastStates.GREY);
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
      showToast(text: 'No image selected.', states: ToastStates.GREY);
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
          'users/${CacheHelper.getData(key: 'userId')}/profiles/${Uri.file(profileImage!.path).pathSegments.last}',
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
          'users/${CacheHelper.getData(key: 'userId')}/covers/${Uri.file(coverImage!.path).pathSegments.last}',
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
        verifiedBadge: userModel!.verifiedBadge,
        latitude: userModel!.latitude ?? 0.0,
        longitude: userModel!.longitude ?? 0.0);
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
      showToast(text: 'No image selected.', states: ToastStates.GREY);
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
          'users/${CacheHelper.getData(key: 'userId')}/posts/${Uri.file(postImageFile!.path).pathSegments.last}',
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
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('postDateTime')
        .snapshots()
        .listen((event) {
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
            });
          });
        });
      });
      emit(AppGetPostOnSuccessState());
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
      uImage: userModel!.image,
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

  void getLocation() {
    // Test if location services are enabled.
    Geolocator.isLocationServiceEnabled().then((serviceEnabled) {
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }
    }).catchError((error) {
      showToast(
        text: error.toString(),
        states: ToastStates.ERROR,
      );
      emit(AppGetLocationOnFailedState());
    });
    Geolocator.checkPermission().then((permission) {
      if (permission == LocationPermission.denied) {
        Geolocator.requestPermission().then((permission) {
          if (permission == LocationPermission.denied) {
            // Permissions are denied, next time you could try
            // requesting permissions again (this is also where
            // Android's shouldShowRequestPermissionRationale
            // returned true. According to Android guidelines
            // your App should show an explanatory UI now.
            return Future.error('Location permissions are denied');
          }
        }).catchError((error) {
          showToast(
            text: error.toString(),
            states: ToastStates.ERROR,
          );
          emit(AppGetLocationOnFailedState());
        });
      }
    }).catchError((error) {
      showToast(
        text: error.toString(),
        states: ToastStates.ERROR,
      );
      emit(AppGetLocationOnFailedState());
    });

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest)
        .then((value) {
      updateUserLocation(
        latitude: value.latitude,
        longitude: value.longitude,
      );
      emit(AppGetLocationOnSuccessState());
    }).catchError((error) {
      showToast(text: error.toString(), states: ToastStates.ERROR);
      emit(AppGetLocationOnFailedState());
    });
  }

  void updateUserLocation({
    required double latitude,
    required double longitude,
  }) {
    UserModel model = UserModel(
        name: userModel!.name,
        phone: userModel!.phone,
        image: userModel!.image,
        cover: userModel!.cover,
        bio: userModel!.bio,
        uId: userModel!.uId,
        isEmailVerified: false,
        email: userModel!.email,
        verifiedBadge: userModel!.verifiedBadge,
        latitude: latitude,
        longitude: longitude);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(AppUpdateUserDataOnFailedState());
    });
  }

  List<UserModel> usersLocations = [];

  void getAllUsersLocations() {
    emit(AppGetAllUsersLocationsOnLoadingState());
    if (usersLocations.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel?.uId) {
            usersLocations.add(UserModel.fromJson(element.data()));
          }
          emit(AppGetAllUsersLocationsOnSuccessState());
        });
      }).catchError((error) {
        emit(AppGetAllUsersLocationsOnFailedState(error.toString()));
      });
    }
  }

  int selectedIndex = 0;

  List<Marker> buildMarkers(PageController pageViewController) {
    final _markerList = <Marker>[];
    for (int i = 0; i < usersLocations.length; i++) {
      final mapItem = usersLocations[i];
      _markerList.add(
        Marker(
          height: MARKER_SIZE_EXPANDED,
          width: MARKER_SIZE_EXPANDED,
          point: LatLng(mapItem.latitude!, mapItem.longitude!),
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                selectedIndex = i;

                pageViewController.animateToPage(
                  i,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                );
                emit(AppChangeMarkerState());
              },
              child: locationMarker(selected: selectedIndex == i),
            );
          },
        ),
      );
    }

    return _markerList;
  }
}
