import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient/patient_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constant.dart';
import '../../models/user_model/user_model.dart';

class FirebaseAuthHelper {
  PatientModel? patientModel;
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage;

  final CollectionReference doctorsCollection =
      FirebaseFirestore.instance.collection('doctors');

  Stream<User?> get getAuthChange => _auth.authStateChanges();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  void signOut() async {
    await _auth.signOut();
  }

  // //
  // Future<bool> loginDoctor(
  //     String email, String password, BuildContext context) async {
  //   try {
  //     showLoaderDialog(context);
  //     QuerySnapshot querySnapshot = await doctorsCollection
  //         .where('email', isEqualTo: email)
  //         .where('password', isEqualTo: password)
  //         .get();
  //     Navigator.of(context).pop();
  //
  //     if (querySnapshot.docs.isNotEmpty) {
  //       saveUserId(querySnapshot.docs.first.id);
  //       return true;
  //     } else {
  //       showMessage("Invalid email or password", context);
  //       return false;
  //     }
  //   } catch (e) {
  //     Navigator.of(context).pop();
  //     showMessage(e.toString(), context);
  //     print('Error logging in as doctor: $e');
  //     return false;
  //   }
  // }
  //
  // Future<bool> registerDoctor(String personId, String name, String email,
  //     String password, String phone, BuildContext context) async {
  //   try {
  //     showLoaderDialog(context);
  //     UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //     UserModel userModel = UserModel(
  //         id: userCredential.user!.uid,
  //         personId: personId,
  //         name: name,
  //         email: email,
  //         phone: phone,
  //         password: password,
  //         image:
  //             'https://firebasestorage.googleapis.com/v0/b/hospital-e86d3.appspot.com/o/profileDoctor.png?alt=media&token=f4ddf1c5-34e7-4f7a-b423-d59a0cc103e5');
  //     _firestore
  //         .collection("doctors")
  //         .doc(userModel.id)
  //         .set(userModel.toJson());
  //     saveUserId(userCredential.user!.uid);
  //     Navigator.of(context, rootNavigator: true).pop();
  //     return true;
  //   } on FirebaseAuthException catch (error) {
  //     Navigator.of(context, rootNavigator: true).pop();
  //     showMessage(error.code.toString(), context);
  //     return false;
  //   }
  // }
}
