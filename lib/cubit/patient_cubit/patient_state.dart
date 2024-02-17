part of 'patient_cubit.dart';

@immutable
abstract class PatientState {}

class PatientInitial extends PatientState {}


class HospitalGetUserLoadingState extends PatientState {}

class HospitalGetUserSuccessState extends PatientState {}

class HospitalGetUserErrorState extends PatientState
{
  final String error;

  HospitalGetUserErrorState(this.error);
}


class VitalSignsLoadingState extends PatientState{}
class VitalSignsSuccessState extends PatientState{}
class VitalSignsErrorState extends PatientState
{
  final String error;

  VitalSignsErrorState(this.error);
}


class HospitalProfileImagePickedSuccessState extends PatientState{}

class HospitalProfileImagePickedErrorState extends PatientState {}


class HospitalUploadProfileImageSuccessState extends PatientState{}

class HospitalUploadProfileImageErrorState extends PatientState {}


class  HospitalUpdateUserLoadingState extends PatientState{}

class HospitalUpdateUserErrorState extends PatientState
{
  final String error;

  HospitalUpdateUserErrorState(this.error);
}