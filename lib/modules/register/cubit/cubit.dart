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
      createUserDate(
        name: name,
        email: email,
        phone: phone,
        uId: value.user!.uid,
      );
    }).catchError((error) {
      emit(RegisterOnFailedState(error.toString()));
    });
  }

  void createUserDate({
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
      image: '',
      cover: '',
      bio: '',
      isEmailVerified: false,
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
