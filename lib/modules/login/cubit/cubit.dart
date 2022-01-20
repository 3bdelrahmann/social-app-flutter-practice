import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginOnLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      emit(LoginOnSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(LoginOnFailedState(error.toString()));
    });
  }

  IconData visibility = Icons.visibility_outlined;
  bool secured = true;

  void changePasswordVisibility() {
    secured = !secured;
    visibility =
        secured ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginOnChangePasswordState());
  }
}
