import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/widgets/bottom_bar.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';

import '../controllers/home_admin_controller.dart';

class HomeAdminView extends GetView<HomeAdminController> {
  const HomeAdminView({Key? key}) : super(key: key);
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
                      "${authC.user.role}",
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
      bottomNavigationBar: GSBottomNavBar(
        currentIndex: 0,
      ),
    );
  }
}
