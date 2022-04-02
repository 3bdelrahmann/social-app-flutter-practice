import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'package:social_app/shared/cubit/states.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return Builder(builder: (context) {
      cubit.getUserData();
      return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(cubit.titles[cubit.currentIndex]),
            actions: [
              IconButton(
                icon: const Icon(IconBroken.Notification),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(IconBroken.Search),
                onPressed: () {},
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Chat),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Location),
                label: 'Nearby',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Profile),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              cubit.changeNavBar(index);
            },
            currentIndex: cubit.currentIndex,
          ),
        ),
      );
    });
  }
}
