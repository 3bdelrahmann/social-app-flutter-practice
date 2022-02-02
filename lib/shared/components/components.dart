import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/shared/styles/colors.dart';

import 'constants.dart';

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
  bool? filled = true,
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
          filled: filled,
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
          margin: const EdgeInsets.only(bottom: 10.0),
          width: double.infinity,
          child: Center(
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          decoration: const BoxDecoration(
            color: kMainColor,
            borderRadius: BorderRadius.vertical(
              bottom: const Radius.circular(180),
            ),
          ),
        )),
        Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(30.0),
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
  double? radius = 10.0,
  double? height = 50.0,
}) =>
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kMainColor,
        borderRadius: BorderRadius.circular(radius!),
      ),
      height: height,
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
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
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      color: Colors.amber.withOpacity(0.8),
      child: Row(
        children: [
          const Icon(Icons.info_outline),
          const SizedBox(
            width: 15.0,
          ),
          const Expanded(
            child: const Text('Please verify your email'),
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

class MyLocationMarker extends AnimatedWidget {
  const MyLocationMarker(Animation<double> animation, {Key? key})
      : super(
          key: key,
          listenable: animation,
        );

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final newValue = lerpDouble(
      0.5,
      1.0,
      value,
    ); //It does not go to zero if it does not reach the middle
    const size = 50.0;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size * newValue!,
          height: size * newValue,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kMainColor.withOpacity(0.5),
          ),
        ),
        Container(
          width: 20.0,
          height: 20.0,
          decoration: const BoxDecoration(
            color: kMainColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

Widget locationMarker({bool selected = false}) => Center(
      child: AnimatedContainer(
        height: selected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINKED,
        width: selected ? MARKER_SIZE_EXPANDED : MARKER_SIZE_SHRINKED,
        duration: const Duration(milliseconds: 200),
        child: SvgPicture.asset(
          'assets/images/marker.svg',
          color: kMainColor,
        ),
      ),
    );

Widget mapItemDetails({required UserModel mapMarker}) => Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        mapMarker.image!,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          mapMarker.name!,
                          // style: _styleTitle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              color: kMainColor,
              elevation: 6.0,
              child: const Text(
                'CALL',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
