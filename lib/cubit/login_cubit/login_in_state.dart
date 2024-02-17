part of 'login_in_cubit.dart';

@immutable
abstract class LoginInState {}

class LoginInInitial extends LoginInState {}
class LoginLoadingState extends LoginInState {}

class LoginSuccessState extends LoginInState
{
  final String uId;

  LoginSuccessState(this.uId);
}

class LoginErrorState extends LoginInState
{
  final String error;

  LoginErrorState(this.error);
}


class CreateUserLoadingState extends LoginInState{}
class CreateUserSuccessState extends LoginInState {}

class CreateUserErrorState extends LoginInState
{
  final String error;

  CreateUserErrorState(this.error);
}

class ChangePasswordVisibilityState extends LoginInState {}



// forgot password state
class AuthForgotPasswordLoading extends LoginInState {
  AuthForgotPasswordLoading();
}

class AuthForgotPasswordSuccess extends LoginInState {
  AuthForgotPasswordSuccess();
}

class AuthForgotPasswordError extends LoginInState {
  final String? err;
  AuthForgotPasswordError(this.err);
  // comparing the objects
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthForgotPasswordError && other.err == err;
  }

  @override
  int get hashCode => err.hashCode;
}