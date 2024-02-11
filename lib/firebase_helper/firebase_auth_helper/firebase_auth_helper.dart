import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constant.dart';
import '../../models/user_model/user_model.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage;
  final CollectionReference patientsCollection =
      FirebaseFirestore.instance.collection('patients');

  final CollectionReference doctorsCollection =
      FirebaseFirestore.instance.collection('doctors');

  Stream<User?> get getAuthChange => _auth.authStateChanges();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> loginPatient(
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      QuerySnapshot querySnapshot = await patientsCollection
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();
      Navigator.of(context).pop();
      if (querySnapshot.docs.isNotEmpty) {
        saveUserId(querySnapshot.docs.first.id);
        return true;
      } else {
        showMessage("Invalid email or password", context);
        return false;
      }
    } catch (e) {
      Navigator.of(context).pop();
      showMessage(e.toString(), context);
      print('Error logging in as patient: $e');
      return false;
    }
  }



  Future<bool> loginDoctor(
      String email, String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      QuerySnapshot querySnapshot = await doctorsCollection
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .get();
      Navigator.of(context).pop();

      if (querySnapshot.docs.isNotEmpty) {
        saveUserId(querySnapshot.docs.first.id);
        return true;
      } else {
        showMessage("Invalid email or password", context);
        return false;
      }
    } catch (e) {
      Navigator.of(context).pop();
      showMessage(e.toString(), context);
      print('Error logging in as doctor: $e');
      return false;
    }
  }

  Future<bool> registerDoctor(String personId, String name, String email,
      String password, String phone, BuildContext context) async {
    try {
      showLoaderDialog(context);
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel = UserModel(
          id: userCredential.user!.uid,
          personId: personId,
          name: name,
          email: email,
          phone: phone,
          password: password,
        image: 'https://firebasestorage.googleapis.com/v0/b/hospital-e86d3.appspot.com/o/profileDoctor.png?alt=media&token=f4ddf1c5-34e7-4f7a-b423-d59a0cc103e5'
      );
      _firestore
          .collection("doctors")
          .doc(userModel.id)
          .set(userModel.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(error.code.toString(), context);
      return false;
    }
  }

  void saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  void signOut() async {
    await _auth.signOut();
  }

  Future<bool> changePassword(String password, BuildContext context) async {
    try {
      showLoaderDialog(context);
      _auth.currentUser!.updatePassword(password);
      // UserCredential userCredential = await _auth
      //     .createUserWithEmailAndPassword(email: email, password: password);
      // UserModel userModel = UserModel(
      //     id: userCredential.user!.uid, name: name, email: email, image: null);

      // _firestore.collection("users").doc(userModel.id).set(userModel.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      showMessage("Password Changed", context);
      Navigator.of(context).pop();

      return true;
    } on FirebaseAuthException catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      showMessage(error.code.toString(), context);
      return false;
    }
  }
}
