import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";

import "package:get/get.dart";
import "package:godsseo/app/data/helpers/formatter.dart";
import "package:godsseo/app/data/helpers/themes.dart";
import "package:godsseo/app/data/models/user_model.dart";
import "package:godsseo/app/data/widgets/bottom_bar.dart";
import "package:godsseo/app/data/widgets/card_column.dart";
import "package:godsseo/app/data/widgets/dialog.dart";
import "package:godsseo/app/data/widgets/tile.dart";
import "package:godsseo/app/modules/auth/controllers/auth_controller.dart";
import "package:nb_utils/nb_utils.dart";

import "../controllers/profile_controller.dart";

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil".tr),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) => GSDialog(
                      title: "Konfirmasi Log Out".tr,
                      subtitle:
                          "Apakah anda yakin akan keluar dari aplikasi ini".tr,
                      negativeText: "Batal".tr,
                      onConfirm: () {
                        authC.signOut();
                      }),
                );
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: Get.width,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CircleAvatar(
                  backgroundColor: primaryColor(context),
                  child: Icon(
                    Icons.person,
                    size: 60,
                  ),
                  foregroundImage: (authC.user.foto.isEmptyOrNull)
                      ? null
                      : CachedNetworkImageProvider(authC.user.foto!),
                  radius: 60),
              16.height,
              GSCardColumn(
                children: [
                  GSTile(
                    leading: Icon(
                      Icons.person,
                      color: primaryColor(context),
                    ),
                    value: authC.user.nickname ?? "",
                    label: "Username".tr,
                  ),
                  Divider(height: 4),
                  GSTile(
                    leading: Icon(
                      Icons.person,
                      color: primaryColor(context),
                    ),
                    value: authC.user.nama ?? "",
                    label: "Nama Lengkap".tr,
                  ),
                  Divider(height: 4),
                  GSTile(
                    leading: Icon(
                      authC.user.gender == "Laki-Laki"
                          ? Icons.male
                          : Icons.female,
                      color: primaryColor(context),
                    ),
                    value: authC.user.gender ?? "",
                    label: "Gender".tr,
                  ),
                  Divider(height: 4),
                  GSTile(
                    leading: Icon(
                      Icons.map,
                      color: primaryColor(context),
                    ),
                    value: authC.user.alamat ?? "",
                    label: "Alamat".tr,
                  ),
                  Divider(height: 4),
                ],
              ),
              16.height,
              GSCardColumn(
                children: [
                  GSTile(
                    leading: Icon(
                      Icons.school,
                      color: primaryColor(context),
                    ),
                    value: authC.user.sekolah ?? "",
                    label: "Asal Sekolah".tr,
                  ),
                  Divider(height: 4),
                  GSTile(
                    leading: Icon(
                      Icons.date_range,
                      color: primaryColor(context),
                    ),
                    value: dateFormatter(authC.user.tglMasuk),
                    label: "Tanggal Masuk".tr,
                  ),
                  Divider(height: 4),
                ],
              ),
              16.height,
              GSCardColumn(
                children: [
                  GSTile(
                    valueStyle: textTheme(context).titleSmall,
                    leading: Icon(
                      Icons.email_rounded,
                      color: primaryColor(context),
                    ),
                    value: authC.user.email ?? "",
                    label: "Email".tr,
                  ),
                  Divider(
                    height: 4,
                  ),
                  GSTile(
                    valueStyle: textTheme(context).titleSmall,
                    value: (authC.user.isActive ?? false)
                        ? "Aktif".tr
                        : "Nonaktif".tr,
                    label: "Status".tr,
                    leading: Icon(
                      Icons.check_circle_outline_rounded,
                      color: primaryColor(context),
                    ),
                  ),
                  Divider(
                    height: 4,
                  ),
                  GSTile(
                    valueStyle: textTheme(context).titleSmall,
                    label: "Role".tr,
                    leading: Icon(
                      Icons.admin_panel_settings,
                      color: primaryColor(context),
                    ),
                    value: authC.user.role ?? "",
                  ),
                  Divider(height: 4),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: authC.user.hasRole(Role.magang)
          ? GSBottomBar()
          : GSBottomNavBar(
              currentIndex: 2,
            ),
    );
  }
}
