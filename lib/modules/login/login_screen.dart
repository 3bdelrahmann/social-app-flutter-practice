import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/main_layout.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';

class LoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final formGlobalKey = GlobalKey<FormState>();

  bool isPasswordValid(String password) => password.length >= 8;

  bool isEmailValid(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    return regex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    LoginCubit cubit = LoginCubit.get(context);
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginOnFailedState) {
          showToast(
            text: state.error,
            states: ToastStates.ERROR,
          );
        }
        if (state is LoginOnSuccessState) {
          CacheHelper.saveData(key: 'userId', value: state.userId)
              .then((value) {
            navigateTo(
              context: context,
              newRoute: MainLayout(),
              backRoute: false,
            );
          }).catchError((error) {
            showToast(
              text: error,
              states: ToastStates.ERROR,
            );
          });
        }
      },
      builder: (context, state) => Scaffold(
        body: entryBuilder(
          title: 'login',
          key: formGlobalKey,
          children: [
            SizedBox(
              height: 10.0,
            ),
            defaultFormField(
              controller: emailController,
              label: 'Email Address',
              type: TextInputType.emailAddress,
              prefix: Icons.email,
              validate: (email) {
                if (isEmailValid(email.toString()))
                  return null;
                else
                  return 'Enter a valid email address';
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            defaultFormField(
              controller: passwordController,
              label: 'Password',
              type: TextInputType.visiblePassword,
              isPassword: cubit.secured,
              suffix: cubit.visibility,
              suffixPressed: () {
                cubit.changePasswordVisibility();
              },
              prefix: Icons.lock,
              validate: (password) {
                if (isPasswordValid(password.toString()))
                  return null;
                else
                  return 'Enter a valid password';
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            ConditionalBuilder(
              condition: state is! LoginOnLoadingState,
              builder: (BuildContext context) => defaultButton(
                onPressed: () {
                  if (formGlobalKey.currentState!.validate()) {
                    cubit.userLogin(
                      email: emailController.text,
                      password: passwordController.text,
                    );
                  }
                },
                text: 'login',
              ),
              fallback: (BuildContext context) =>
                  Center(child: CircularProgressIndicator()),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account?',
                ),
                defaultTextButton(
                    onPressed: () {
                      navigateTo(
                        context: context,
                        newRoute: RegisterScreen(),
                        backRoute: true,
                      );
                    },
                    text: 'Register Now'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
