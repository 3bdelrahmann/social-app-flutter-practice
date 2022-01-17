abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterOnLoadingState extends RegisterStates {}

class RegisterOnSuccessState extends RegisterStates {}

class RegisterOnFailedState extends RegisterStates {
  final String error;

  RegisterOnFailedState(this.error);
}

class RegisterOnChangePasswordState extends RegisterStates {}
