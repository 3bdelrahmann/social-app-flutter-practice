import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/modules/register/register_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/colors.dart';

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
      listener: (context, state) {},
      builder: (context, state) => Scaffold(
        backgroundColor: kMainColor,
        body: reusableFormCard(
          key: formGlobalKey,
          children: [
            Text(
              'LOGIN',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(
                  Icons.email,
                ),
                border: OutlineInputBorder(),
              ),
              validator: (email) {
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
            defaultButton(
              text: 'login',
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (formGlobalKey.currentState!.validate()) {}
              },
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
