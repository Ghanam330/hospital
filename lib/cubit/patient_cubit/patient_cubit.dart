import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/models/patient/patient_model.dart';
import 'package:hospital/screen/doctor_app/patient_screen/vitalSigns/vital_sign_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constant.dart';
import '../../models/patient/vital_signs_model.dart';
import '../../screen/doctor_app/patient_screen/patient_details_screen.dart';

part 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  PatientCubit() : super(PatientInitial());

  static PatientCubit get(context) => BlocProvider.of(context);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PatientModel? patientModel;
  VitalSignsModel? vitalSignsModel;
  List<VitalSignsModel> vitalSignsList = [];
  File? profileImage;
  final picker = ImagePicker();

  void getSnapShot(String id) async {
    emit(HospitalGetUserLoadingState());
    try {
      await firestore.collection("patients").doc(id).get().then((value) {
        patientModel = PatientModel.fromMap(value.data()!);
        emit(HospitalGetUserSuccessState());
      });
    } catch (e) {
      emit(HospitalGetUserErrorState(e.toString()));
    }
  }

  void getVitalSigns() async {
    emit(VitalSignsLoadingState());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userIdPatient');
      QuerySnapshot querySnapshot = await firestore
          .collection("patients")
          .doc(userId)
          .collection("VitalSigns")
          .get();
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        VitalSignsModel vitalSignsModel = VitalSignsModel.fromMap(data);
        vitalSignsList.add(vitalSignsModel);
        emit(VitalSignsSuccessState());
      }
    } catch (e) {
      emit(VitalSignsErrorState(e.toString()));
    }
  }

  void setVitalSigns(
    String temperature,
    String heartRate,
    String oxygenLevel,
    String appointmentDate,
    BuildContext context,
  ) async {
    emit(VitalSignsLoadingState());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userIdPatient');
      VitalSignsModel vitalSignsModel = VitalSignsModel(
        appointmentDate: appointmentDate,
        temperature: heartRate,
        heartRate: heartRate,
        oxygenLevel: oxygenLevel,
      );
      await firestore
          .collection("patients")
          .doc(userId)
          .collection("VitalSigns")
          .doc(appointmentDate)
          .set(vitalSignsModel.toMap())
          .then((value) {

        emit(VitalSignsSuccessState());
        Fluttertoast.showToast(msg: "Add VitalSigns Success");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>VitalSignsScreen()
               ,
          ),
        );
      });
    } catch (e) {
      emit(VitalSignsErrorState(e.toString()));
    }
  }


  void updateVitalSigns(
      String temperature,
      String heartRate,
      String oxygenLevel,
      String appointmentDate,
      BuildContext context,
      ) async {
    emit(VitalSignsLoadingState());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userIdPatient');
      VitalSignsModel vitalSignsModel = VitalSignsModel(
        appointmentDate: appointmentDate,
        temperature: heartRate,
        heartRate: heartRate,
        oxygenLevel: oxygenLevel,
      );
      await firestore
          .collection("patients")
          .doc(userId)
          .collection("VitalSigns")
          .doc(appointmentDate)
          .update(vitalSignsModel.toMap())
          .then((value) {
        emit(VitalSignsSuccessState());
        Fluttertoast.showToast(msg: "Update VitalSigns Success");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>VitalSignsScreen()
            ,
          ),
        );
      });
    } catch (e) {
      emit(VitalSignsErrorState(e.toString()));
    }
  }

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(HospitalProfileImagePickedSuccessState());
      showToast(text: "Image select", state: ToastStates.SUCCESS);
    } else {
      showToast(text: "No Image select", state: ToastStates.ERROR);
      emit(HospitalProfileImagePickedErrorState());
    }
  }

  void uploadProfileImage({
    required name,
    required phone,
    required appointmentDate,
    required examinationPrice,
    required age,
    required gender,
    required context,
  }) {
    emit(HospitalUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('patient/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
            name: name,
            phone: phone,
            appointmentDate: appointmentDate,
            examinationPrice: examinationPrice,
            gender: gender,
            age: age,
            context: context);
        showToast(text: "Upload Image SUCCESS", state: ToastStates.SUCCESS);
      }).catchError((error) {
        emit(HospitalUploadProfileImageErrorState());
        showToast(text: "Can't Upload Image Error", state: ToastStates.ERROR);
      });
    }).catchError((onError) {
      showToast(text: "Can't Upload Image Error", state: ToastStates.ERROR);
      emit(HospitalUploadProfileImageErrorState());
    });
  }

  void updateUser(
      {required name,
      required phone,
      String? image,
      required String appointmentDate,
      required String examinationPrice,
      required String gender,
      required String age,
      required BuildContext context}) {
    PatientModel model = PatientModel(
      id: patientModel!.id,
      patientName: name,
      phoneNumber: phone,
      email: patientModel!.email,
      password: patientModel!.password,
      appointmentDate: appointmentDate,
      examinationPrice: examinationPrice,
      gender: gender,
      age: age,
      doctorName: patientModel!.doctorName,
      registeredSection: patientModel!.registeredSection,
      imageUrl: image ?? patientModel!.imageUrl,
    );
    emit(HospitalUpdateUserLoadingState());
    FirebaseFirestore.instance
        // .collection("sections")
        // .doc(patientModel!.registeredSection)
        // .collection("doctorName")
        // .doc(patientModel!.doctorName)
        .collection("patients")
        .doc(patientModel!.id)
        .update(model.toMap())
        .then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PatientDetailsScreen(patientModel: patientModel!),
        ),
      );
      // get user
      // Navigator.pop(context);
      showToast(text: "Update User SUCCESS", state: ToastStates.SUCCESS);
    }).catchError((onError) {
      emit(HospitalUpdateUserErrorState(onError));
      showToast(text: "Can't Update", state: ToastStates.ERROR);
    });
  }
}
