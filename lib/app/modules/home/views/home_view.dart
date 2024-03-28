import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/widgets/bottom_bar.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Obx(
                  () => ListTile(
                    title: Text(
                      "Hello, ${authC.user.nickname}",
                      style: textTheme(context)
                          .titleLarge
                          ?.copyWith(color: primaryColor(context)),
                    ),
                    subtitle: Text(
                      "This is your day ${authC.user.countInternDays()} internship here",
                      style: textTheme(context).labelLarge,
                    ),
                    trailing: CircleAvatar(child: Icon(Icons.person)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor(context),
        onPressed: () {
          toast("Go to Presensi Page");
        },
        child: Icon(
          Icons.fingerprint_rounded,
          size: 36,
        ),
      ),
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: GSBottomBar(),
    );
  }
}
