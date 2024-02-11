part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}


class HospitalGetUserLoadingState extends UserState {}

class HospitalGetUserSuccessState extends UserState {}

class HospitalGetUserErrorState extends UserState
{
  final String error;

  HospitalGetUserErrorState(this.error);
}



class HospitalProfileImagePickedSuccessState extends UserState{}

class HospitalProfileImagePickedErrorState extends UserState {}


class HospitalUploadProfileImageSuccessState extends UserState{}

class HospitalUploadProfileImageErrorState extends UserState {}


class  HospitalUpdateUserLoadingState extends UserState{}

class HospitalUpdateUserErrorState extends UserState
{
  final String error;

  HospitalUpdateUserErrorState(this.error);
}