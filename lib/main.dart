import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/cubit.dart';
import 'package:social_app/modules/onBoarding/on_boarding_screen.dart';
import 'package:social_app/modules/register/cubit/cubit.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'shared/bloc_observer.dart';
import 'shared/network/local/cache_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () {
      AppCubit();
    },
    blocObserver: MyBlocObserver(),
  );
  await Firebase.initializeApp();
  await CacheHelper.init();

  runApp(SocialApp());
}

class SocialApp extends StatelessWidget {
  const SocialApp({Key? key}) : super(key: key);

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
                  theme: ThemeData(
                    primarySwatch: kMainColor,
                  ),
                  home: OnBoardingScreen(),
                )));
  }
}
