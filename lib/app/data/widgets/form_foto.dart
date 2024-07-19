// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:godsseo/app/data/helpers/assets.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

Future<XFile?> imagePickerBottomSheet(BuildContext context) async {
  final ImagePicker _picker = ImagePicker();

  getImage(ImageSource source) async {
    try {
      return await _picker.pickImage(source: source);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  XFile? result;

  await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
    builder: (context) => Container(
      height: 200,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 16, left: 16),
            child: Text("Image Source"),
          ),
          ListTile(
              title: Text("Camera"),
              leading: Icon(
                Icons.camera,
                color: primaryColor(context),
              ),
              onTap: () async {
                result = await getImage(ImageSource.camera);
                Get.back();
              }),
          ListTile(
              title: Text("Gallery"),
              leading: Icon(
                Icons.photo,
                color: primaryColor(context),
              ),
              onTap: () async {
                result = await getImage(ImageSource.gallery);
                Get.back();
              }),
        ],
      ),
    ),
  );
  return result;
}

class GSFormFoto extends StatelessWidget {
  String oldPath = '';
  String defaultPath;
  bool showButton = true;
  GSFormFoto({
    this.oldPath = '',
    this.defaultPath = img_logo,
    this.showButton = true,
  });
  var xfoto = ''.obs;
  String get newPath => xfoto.value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 16),
            width: Get.width / 2,
            height: Get.width / 2,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: newPath.isNotEmpty
                  ? Image.file(File(newPath))
                  : oldPath.isNotEmpty
                      ? Image.network(
                          oldPath,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          defaultPath,
                        ),
            ),
          ),
        ),
        if (showButton)
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24))),
            child: Text(
              "Upload Foto",
            ),
            onPressed: () async {
              var res = await imagePickerBottomSheet(context);
              if (res is XFile) {
                xfoto.value = res.path;
              }
            },
          ),
      ],
    );
  }
}
