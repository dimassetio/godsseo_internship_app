import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/data/widgets/bottom_bar.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProfileView'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text("Sign Out"),
              leading: Icon(Icons.logout_rounded),
              onTap: () {
                authC.signOut();
              },
            )
          ],
        ),
      ),
      floatingActionButton: authC.user.hasRole(Role.magang)
          ? FloatingActionButton(
              backgroundColor: primaryColor(context),
              onPressed: () {
                toast("Go to Presensi Page");
              },
              child: Icon(
                Icons.fingerprint_rounded,
                size: 36,
              ),
            )
          : null,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: authC.user.hasRole(Role.magang)
          ? GSBottomBar()
          : GSBottomNavBar(
              currentIndex: 2,
            ),
    );
  }
}
