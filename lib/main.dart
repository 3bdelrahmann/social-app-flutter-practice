import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/onBoarding/on_boarding_screen.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/themes.dart';
import 'layout/main_layout.dart';
import 'modules/login/login_screen.dart';
import 'shared/bloc_observer.dart';
import 'shared/network/local/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () {
      LoginCubit();
      AppCubit();
      RegisterCubit();
    },
    blocObserver: MyBlocObserver(),
  );
  await Firebase.initializeApp();
  await CacheHelper.init();

  runApp(SocialApp(
    onBoarding: CacheHelper.getData(key: 'onBoarding') ?? false,
    userId: CacheHelper.getData(key: 'userId') ?? ' ',
  ));
}

class SocialApp extends StatelessWidget {
  final bool onBoarding;
  final String userId;

  const SocialApp({Key? key, required this.onBoarding, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => RegisterCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => AppCubit(),
        )
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          home: ConditionalBuilder(
              condition: onBoarding,
              builder: (BuildContext context) => ConditionalBuilder(
                  condition: userId.trim().isNotEmpty,
                  builder: (BuildContext context) => const MainLayout(),
                  fallback: (BuildContext context) => LoginScreen()),
              fallback: (BuildContext context) => const OnBoardingScreen()),
        ),
      ),
    );
  }
}
