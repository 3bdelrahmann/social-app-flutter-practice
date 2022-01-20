abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

class RegisterOnLoadingState extends RegisterStates {}

class RegisterOnSuccessState extends RegisterStates {}

class RegisterOnFailedState extends RegisterStates {
  final String error;

  RegisterOnFailedState(this.error);
}

class CreateUserOnLoadingState extends RegisterStates {}

class CreateUserOnSuccessState extends RegisterStates {
  final String userId;

  CreateUserOnSuccessState(this.userId);
}

class CreateUserOnFailedState extends RegisterStates {
  final String error;

  CreateUserOnFailedState(this.error);
}

class RegisterOnChangePasswordState extends RegisterStates {}
