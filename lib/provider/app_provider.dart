// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/constant.dart';
import '../firebase_helper/firebase_storage_helper/firebase_storage_helper.dart';

import '../models/user_model/user_model.dart';

enum AuthForgotPasswordStatus { initial, loading, success, error }

class AppProvider with ChangeNotifier {

  UserModel? _userModel;

  UserModel get getUserInformation => _userModel!;

  void updateUserInfoFirebase(
      BuildContext context, UserModel userModel, File? file) async {
    if (file == null) {
      showLoaderDialog(context);

      _userModel = userModel;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    } else {
      showLoaderDialog(context);
      String imageUrl =
          await FirebaseStorageHelper.instance.uploadUserImage(file);
      _userModel = userModel.copyWith(image: imageUrl);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_userModel!.id)
          .set(_userModel!.toJson());
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context).pop();
    }
    showMessage("Successfully updated profile");

    notifyListeners();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthForgotPasswordStatus _forgotPasswordStatus = AuthForgotPasswordStatus.initial;

  AuthForgotPasswordStatus get forgotPasswordStatus => _forgotPasswordStatus;

  Future<void> forgotPassword(String email) async {
    _forgotPasswordStatus = AuthForgotPasswordStatus.loading;
    notifyListeners();

    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      _forgotPasswordStatus = AuthForgotPasswordStatus.success;
      Fluttertoast.showToast(msg: "Successful Check Email");
    } on FirebaseAuthException catch (e) {
      _forgotPasswordStatus = AuthForgotPasswordStatus.error;
      Fluttertoast.showToast(msg: e.message!);
    }

    notifyListeners();
  }
}
