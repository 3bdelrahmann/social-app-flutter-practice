import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/register/cubit/states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    emit(RegisterOnLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      createUserData(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      emit(RegisterOnFailedState(error.toString()));
    });
  }

  void createUserData({
    required String name,
    required String email,
    required String phone,
    required String uId,
  }) {
    emit(CreateUserOnLoadingState());
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      uId: uId,
      image:
          'https://firebasestorage.googleapis.com/v0/b/social-app-44b0e.appspot.com/o/default-profile.jpg?alt=media&token=2fec4ce5-0f29-4547-9c16-1401e8e32737',
      cover:
          'https://firebasestorage.googleapis.com/v0/b/social-app-44b0e.appspot.com/o/default-cover.jpg?alt=media&token=d60819f8-5673-455c-9d70-2684a5d9754b',
      bio: 'bio ...',
      isEmailVerified: false,
      verifiedBadge: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserOnSuccessState(uId));
    }).catchError((error) {
      emit(CreateUserOnFailedState(error));
    });
  }

  IconData visibility = Icons.visibility_outlined;
  bool secured = true;

  void changePasswordVisibility() {
    secured = !secured;
    visibility =
        secured ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterOnChangePasswordState());
  }
}
