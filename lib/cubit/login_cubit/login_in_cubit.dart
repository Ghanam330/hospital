import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital/models/user_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/strings.dart';
import '../../models/patient/patient_model.dart';
import '../../screen/doctor_app/homescreen/home_screen.dart';
import '../../screen/doctor_app/patient_screen/patient_details_screen.dart';
import '../../screen/patient_app/patientapp_details_screen.dart';

part 'login_in_state.dart';

class LoginInCubit extends Cubit<LoginInState> {
  LoginInCubit() : super(LoginInInitial());

  static LoginInCubit get(context) => BlocProvider.of(context);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  PatientModel? patientModel;
  UserModel? userModel;

  void loginPatient(
    String email,
    String password,
    BuildContext context,
    String registeredSection,
    String doctorName,
  ) async {
    try {
      emit(LoginLoadingState());
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore.instance
          .collection("patients")
          .where("id", isEqualTo: userCredential.user!.uid)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        if (querySnapshot.size > 0) {
          // Assuming there is only one document with the specified ID
          patientModel = PatientModel.fromMap(querySnapshot.docs.first.data());
          if (patientModel!.doctorName == doctorName &&
              patientModel!.registeredSection == registeredSection) {
            emit(LoginSuccessState(userCredential.user!.uid));
            saveIdPatient(userCredential.user!.uid);
            Fluttertoast.showToast(msg: "Login Successful");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PatientDetailsScreen(patientModel: patientModel!),
              ),
            );
          } else if (patientModel!.registeredSection != registeredSection) {
            emit(LoginErrorState("Patient not found in this Section"));
            Fluttertoast.showToast(msg: "Patient not found in this Section");
          } else {
            emit(LoginErrorState("Patient not found in this doctor"));
            Fluttertoast.showToast(msg: "Patient not found in this doctor");
          }
        } else {
          emit(LoginErrorState("Patient not found"));
          Fluttertoast.showToast(msg: "Patient not found");
        }
      });
    } on FirebaseAuthException catch (error) {
      emit(LoginErrorState(error.toString()));
      Fluttertoast.showToast(msg: "Error logging in as patient: $error");
    }
  }

  void registerPatient(
    String name,
    String email,
    String password,
    String phone,
    String appointmentDate,
    String examinationPrice,
    String gender,
    String age,
    String doctorName,
    String registeredSection,
    BuildContext context,
  ) async {
    try {
      emit(LoginLoadingState());
      UserCredential userPatientCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Initialize the User with the new fields
      PatientModel patientModel = PatientModel(
        id: userPatientCredential.user!.uid,
        patientName: name,
        phoneNumber: phone,
        email: email,
        password: password,
        appointmentDate: appointmentDate,
        examinationPrice: examinationPrice,
        gender: gender,
        age: age,
        doctorName: doctorName,
        registeredSection: registeredSection,
        imageUrl:
            'https://firebasestorage.googleapis.com/v0/b/hospital-e86d3.appspot.com/o/Avatar%2C%20checkup%2C%20examination%2C%20health%2C%20medical%2C%20patient%2C%20stethoscope%20icon%20-%20Download%20on%20Iconfinder.jpg?alt=media&token=fb576d4f-7071-4332-bc75-327350e53fcd',
      );
      await _firestore
          // .collection("sections")
          // .doc(patientModel.registeredSection)
          // .collection("doctorName")
          // .doc(doctorName)
          .collection("patients")
          .doc(patientModel.id)
          .set(patientModel.toMap())
          .then((value) {
        emit(LoginSuccessState(patientModel.id));
        saveIdPatient(patientModel.id);
        Fluttertoast.showToast(msg: "Login Successful");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    PatientDetailsScreen(patientModel: patientModel)));
      });
    } on FirebaseAuthException catch (error) {
      emit(LoginErrorState(error.toString()));
      Fluttertoast.showToast(msg: "Error logging in as patient: $error");
    }
  }



  Future forgotPassword(String email) async {
    emit(AuthForgotPasswordLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(AuthForgotPasswordSuccess());
      Fluttertoast.showToast(msg: "Successful Check Email");
    } on FirebaseAuthException catch (e) {
      emit(AuthForgotPasswordError(e.message));
      Fluttertoast.showToast(msg: e.message!);
    }
  }

  // appPatient
  void loginAppPatient(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      emit(LoginLoadingState());
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore.instance
          .collection("patients")
          .where("id", isEqualTo: userCredential.user!.uid)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        if (querySnapshot.size > 0) {
          // Assuming there is only one document with the specified ID
          patientModel = PatientModel.fromMap(querySnapshot.docs.first.data());
          emit(LoginSuccessState(userCredential.user!.uid));
          Fluttertoast.showToast(msg: "Login Successful");
          saveUserIdOption(querySnapshot.docs.first.id,'Patient');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => PatientAppDetailsScreen()),
              (Route<dynamic> route) => false);
        } else {
          emit(LoginErrorState("Patient not found"));
          Fluttertoast.showToast(msg: "Patient not found");
        }
      });
    } on FirebaseAuthException catch (error) {
      emit(LoginErrorState(error.toString()));
      Fluttertoast.showToast(msg: "Error logging in as patient: $error");
    }
  }

  void loginAppDoctor(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      emit(LoginLoadingState());
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      FirebaseFirestore.instance
          .collection("doctors")
          .where("id", isEqualTo: userCredential.user!.uid)
          .get()
          .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
        if (querySnapshot.size > 0) {
          // // Assuming there is only one document with the specified ID
          // userModel = UserModel.fromJson(querySnapshot.docs.first.data());
          emit(LoginSuccessState(userCredential.user!.uid));
          saveUserIdOption(querySnapshot.docs.first.id,'Doctor');

          Fluttertoast.showToast(msg: "Login Successful");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()),
              (Route<dynamic> route) => false);
        } else {
          emit(LoginErrorState("Doctor not found"));
          Fluttertoast.showToast(msg: "Doctor not found");
        }
      });
    } on FirebaseAuthException catch (error) {
      emit(LoginErrorState(error.toString()));
      Fluttertoast.showToast(msg: "Error logging in as patient: $error");
    }
  }

  void registerDoctor(String personId, String name, String email,
      String password, String phone, BuildContext context) async {
    try {
      emit(LoginLoadingState());
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          personId: personId,
          name: name,
          email: email,
          phone: phone,
          password: password,
          image:
              'https://firebasestorage.googleapis.com/v0/b/hospital-e86d3.appspot.com/o/profileDoctor.png?alt=media&token=f4ddf1c5-34e7-4f7a-b423-d59a0cc103e5');
      FirebaseFirestore.instance
          .collection("doctors")
          .doc(userModel.id)
          .set(userModel.toJson())
          .then((value) {
        saveUserIdOption(userCredential.user!.uid,'Doctor');
        emit(LoginSuccessState(userCredential.user!.uid));
        Navigator.pushNamedAndRemoveUntil(
            context, homeScreen, (route) => false);
      });
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: "Error logging in as doctor: $error");
    }
  }

void saveIdPatient(String userId)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userIdPatient', userId);
}
  void saveUserIdOption(String userId ,option) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
    prefs.setString('option', option);
  }
}
