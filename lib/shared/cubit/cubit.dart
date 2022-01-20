import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/home/home_screen.dart';
import 'package:social_app/modules/nearby/nearby_screen.dart';
import 'package:social_app/modules/profile/profile_screen.dart';
import 'package:social_app/shared/components/constants.dart';
import 'package:social_app/shared/cubit/states.dart';

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
      print(error.toString());
      emit(AppGetUserOnFailedState(error.toString()));
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    ChatsScreen(),
    NearbyScreen(),
    ProfileScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Nearby',
    'Profile',
  ];

  void ChangeNavBar(int index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }
}
