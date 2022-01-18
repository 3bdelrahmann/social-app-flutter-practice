import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/main_layout.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
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
    RegisterCubit cubit = RegisterCubit.get(context);
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is CreateUserOnSuccessState) {
          navigateTo(
            context: context,
            newRoute: MainLayout(),
            backRoute: false,
          );
        }
      },
      builder: (context, state) => Scaffold(
        body: entryBuilder(
          key: formGlobalKey,
          title: 'Register',
          children: [
            defaultFormField(
              controller: userNameController,
              label: 'Full Name',
              type: TextInputType.name,
              prefix: Icons.person,
              validate: (name) {
                if (name!.isEmpty) return 'Complete all fields';
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            defaultFormField(
              controller: emailController,
              label: 'Email Address',
              type: TextInputType.emailAddress,
              prefix: Icons.email,
              validate: (email) {
                if (!isEmailValid(email.toString()))
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
                if (!isPasswordValid(password.toString()))
                  return 'Enter a valid password';
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            defaultFormField(
              controller: phoneController,
              label: 'Phone',
              type: TextInputType.phone,
              prefix: Icons.phone,
              validate: (number) {
                if (number!.isEmpty) return 'Complete all fields';
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            ConditionalBuilder(
              condition: state is! RegisterOnLoadingState,
              builder: (BuildContext context) => defaultButton(
                onPressed: () {
                  if (formGlobalKey.currentState!.validate()) {
                    RegisterCubit.get(context).userRegister(
                      name: userNameController.text,
                      email: emailController.text,
                      password: passwordController.text,
                      phone: phoneController.text,
                    );
                  }
                },
                text: 'Register',
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
                  'Already a member?',
                ),
                defaultTextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: 'Login Now'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
