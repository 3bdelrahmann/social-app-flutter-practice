abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginOnLoadingState extends LoginStates {}

class LoginOnSuccessState extends LoginStates {
  final String userId;

  LoginOnSuccessState(this.userId);
}

class LoginOnFailedState extends LoginStates {
  final String error;

  LoginOnFailedState(this.error);
}

class LoginOnChangePasswordState extends LoginStates {}
