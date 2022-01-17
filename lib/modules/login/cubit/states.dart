abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginOnLoadingState extends LoginStates {}

class LoginOnSuccessState extends LoginStates {}

class LoginOnFailedState extends LoginStates {
  final String error;

  LoginOnFailedState(this.error);
}

class LoginOnChangePasswordState extends LoginStates {}
