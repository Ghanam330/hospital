import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital/models/user_model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constant.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  static UserCubit get(context) => BlocProvider.of(context);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  UserModel? userModel;

  void getSnapShot() async {
    emit(HospitalGetUserLoadingState());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      print(userId);
      await firestore
          .collection("doctors")
          .doc(userId)
          .get()
          .then((value) {
        userModel = UserModel.fromJson(value.data()!);
        emit(HospitalGetUserSuccessState());
      });
    } catch (e) {
      emit(HospitalGetUserErrorState(e.toString()));
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

  void uploadProfileImage({required name, required phone, required personId}) {
    emit(HospitalUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri
        .file(profileImage!.path)
        .pathSegments
        .last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, phone: phone,  image: value,personId: personId);
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
      {required name, required phone, String? image, required String personId}) {
    UserModel model = UserModel(
      name: name,
      email: userModel!.email,
      phone: phone,
      id: userModel!.id,
      image: image ?? userModel!.image,
      personId: personId,
      password: userModel!.password,
    );

    emit(HospitalUpdateUserLoadingState());
    FirebaseFirestore.instance
        .collection('doctors')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(model.toJson())
        .then((value) {
      getSnapShot();
      // get user
      showToast(text: "Update User SUCCESS", state: ToastStates.SUCCESS);
    }).catchError((onError) {
      emit(HospitalUpdateUserErrorState(onError));
      showToast(text: "Can't Update", state: ToastStates.ERROR);
    });
  }

}
