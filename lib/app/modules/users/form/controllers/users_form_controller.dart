import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/formatter.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:nb_utils/nb_utils.dart';

class UsersFormController extends GetxController {
  bool isEdit = false;
  GlobalKey<FormState> formKey = GlobalKey();

  final _isLoading = false.obs;
  get isLoading => _isLoading.value;
  set isLoading(value) => _isLoading.value = value;

  TextEditingController usernameC = TextEditingController();
  TextEditingController fullnameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController alamatC = TextEditingController();
  TextEditingController sekolahC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController confirmPasswordC = TextEditingController();
  TextEditingController tglMasukC = TextEditingController();

  String? selectedRole;
  DateTime? selectedTglMasuk;
  String? selectedGender;
  bool? isActive;

  var selectedPhotoPath = ''.obs;

  List genderList = [
    "Laki-Laki",
    "Perempuan",
  ];

  UserModel? editedUser;

  void loadController() {
    if (editedUser is UserModel) {
      usernameC.text = editedUser!.nickname ?? '';
      fullnameC.text = editedUser!.nama ?? '';
      emailC.text = editedUser!.email ?? '';
      alamatC.text = editedUser!.alamat ?? '';
      sekolahC.text = editedUser!.sekolah ?? '';
      tglMasukC.text = dateFormatter(editedUser!.tglMasuk);
      selectedRole = editedUser!.role;
      selectedTglMasuk = editedUser!.tglMasuk;
      selectedGender = editedUser!.gender;
      isActive = editedUser!.isActive;
    }
  }

  Future save() async {
    try {
      isLoading = true;
      UserModel user = editedUser ?? UserModel();
      // Register User
      bool isSet = false;
      if (editedUser == null) {
        var userCredential =
            await authC.createUser(emailC.text, passwordC.text);
        if (userCredential.user != null) {
          user.id = userCredential.user!.uid;
          user.uid = userCredential.user!.uid;
          isSet = true;
          await userCredential.user!.sendEmailVerification();
          toast("Email verification sent".trParams({'email': emailC.text}));
        }
      }
      user.nama = fullnameC.text;
      user.role = selectedRole;
      user.email = emailC.text;
      user.nickname = usernameC.text;
      user.sekolah = sekolahC.text;
      user.tglMasuk = selectedTglMasuk;
      user.gender = selectedGender;
      user.alamat = alamatC.text;
      user.isActive = isActive;

      File? fileFoto = selectedPhotoPath.value.isEmptyOrNull
          ? null
          : File(selectedPhotoPath.value);

      await user.save(file: fileFoto, isSet: isSet);
    } catch (e) {
      printError(info: e.toString());
      Get.snackbar("Error".tr, e.toString());
    } finally {
      isLoading = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    isEdit = Get.arguments is UserModel;
    if (isEdit) {
      editedUser = Get.arguments;
      loadController();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
