abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppGetUserOnLoadingState extends AppStates {}

class AppGetUserOnSuccessState extends AppStates {}

class AppGetUserOnFailedState extends AppStates {
  final String error;

  AppGetUserOnFailedState(this.error);
}

class AppChangeNavBarState extends AppStates {}
