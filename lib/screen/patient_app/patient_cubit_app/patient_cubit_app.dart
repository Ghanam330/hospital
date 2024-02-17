import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital/models/patient/patient_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/constant.dart';
import '../../../models/patient/vital_signs_model.dart';
import '../patientapp_details_screen.dart';


part 'patient_state_app.dart';

class PatientAppCubit extends Cubit<PatientState> {
  PatientAppCubit() : super(PatientInitial());

  static PatientAppCubit get(context) => BlocProvider.of(context);

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  PatientModel? patientModel;
  VitalSignsModel? vitalSignsModel;
  List<VitalSignsModel> vitalSignsList = [];

  void getSnapShotPatientApp() async {
    emit(HospitalGetUserLoadingState());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      print(userId);
      await firestore
          .collection("patients")
          .doc(userId)
          .get()
          .then((value) {
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
      String? userId = prefs.getString('userId');
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

  File? profileImage;
  final picker = ImagePicker();

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

  void uploadProfileImage(
      {required name, required phone, required age, required gender,
        required context,
      }) {
    emit(HospitalUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('patient/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(
            name: name,
            phone: phone,

            gender: gender,
            age: age,

        context: context
        );
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

  void updateUser({required name,
    required phone,
    String? image,
    required String gender,
    required String age,
    required BuildContext context
  }) {
    PatientModel model = PatientModel(
      id: patientModel!.id,
      patientName: name,
      phoneNumber: phone,
      email: patientModel!.email,
      password: patientModel!.password,
      appointmentDate: patientModel!.appointmentDate,
      examinationPrice:patientModel!.examinationPrice,
      gender: gender,
      age: age,
      doctorName: patientModel!.doctorName,
      registeredSection: patientModel!.registeredSection,

      imageUrl: image ?? patientModel!.imageUrl,
    );
    emit(HospitalUpdateUserLoadingState());
    FirebaseFirestore.instance
        .collection("patients")
        .doc(patientModel!.id)
        .update(model.toMap())
        .then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PatientAppDetailsScreen(),
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
