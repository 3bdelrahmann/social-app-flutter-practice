import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/colors.dart';

void navigateTo(
        {required BuildContext context,
        required Widget newRoute,
        required bool backRoute}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => newRoute),
      (route) => backRoute,
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator<String> validate,
  required IconData prefix,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  GestureTapCallback? onTap,
  bool isPassword = false,
  String? label,
  String? hint,
  IconData? suffix,
  VoidCallback? suffixPressed,
  bool isClickable = true,
  bool readOnly = false,
  int? maxLength,
  double radius = 10.0,
}) =>
    Container(
      color: Colors.white,
      child: TextFormField(
        maxLength: maxLength,
        readOnly: readOnly,
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        enabled: isClickable,
        onFieldSubmitted: onSubmit,
        onChanged: onChange,
        onTap: onTap,
        validator: validate,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          prefixIcon: Icon(
            prefix,
          ),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixPressed,
                  icon: Icon(
                    suffix,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          filled: true,
        ),
      ),
    );

Widget reusableFormCard({
  Key? key,
  required List<Widget> children,
}) =>
    Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          padding: const EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                children: children,
              ),
            ),
          ),
        ),
      ),
    );

Widget entryBuilder({
  Key? key,
  required String title,
  required List<Widget> children,
}) =>
    Column(
      children: [
        Expanded(
            child: Container(
          margin: EdgeInsets.only(bottom: 10.0),
          width: double.infinity,
          child: Center(
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: kMainColor,
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(180),
            ),
          ),
        )),
        Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(30.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: key,
                    child: Column(
                      children: children,
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
Widget defaultButton({
  required String text,
  required VoidCallback onPressed,
}) =>
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kMainColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: 50.0,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultTextButton({
  required VoidCallback onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text.toUpperCase(),
      ),
    );

void showToast({
  required String text,
  required ToastStates states,
}) =>
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: chooseToastColor(states),
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastStates { SUCCESS, ERROR, WARNING, GREY }

Color chooseToastColor(ToastStates states) {
  Color color;
  switch (states) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
    case ToastStates.GREY:
      color = Colors.grey;
      break;
  }
  return color;
}

Widget roundIconButton({
  required IconData icon,
  required VoidCallback onPressed,
  required Color color,
  Color? iconColor,
}) =>
    RawMaterialButton(
      elevation: 0.0,
      child: Icon(
        icon,
        color: iconColor,
      ),
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(
        width: 60.0,
        height: 60.0,
      ),
      shape: const CircleBorder(),
      fillColor: color,
    );
Widget verifyEmailNotifier() => Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      color: Colors.amber.withOpacity(0.8),
      child: Row(
        children: [
          Icon(Icons.info_outline),
          SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: Text('Please verify your email'),
          ),
          defaultTextButton(
              onPressed: () {
                FirebaseAuth.instance.currentUser?.sendEmailVerification();
                showToast(text: 'Sent', states: ToastStates.SUCCESS);
              },
              text: 'send'),
        ],
      ),
    );

Widget withNotifier({required Widget child}) => Stack(
      children: [
        child,
        if (!FirebaseAuth.instance.currentUser!.emailVerified)
          verifyEmailNotifier(),
      ],
    );
