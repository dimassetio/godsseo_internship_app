import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/assets.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/auth_email_confirmation_controller.dart';

class AuthEmailConfirmationView
    extends GetView<AuthEmailConfirmationController> {
  const AuthEmailConfirmationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme(context).scaffoldBackgroundColor,
          leadingWidth: Get.width,
          leading: Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
                onPressed: () {
                  Get.back();
                },
                label: Text("Kembali"),
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: primaryColor(context),
                )),
          ),
        ),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    svg_verification,
                    height: 200,
                  ),
                  16.height,
                  Text(
                    "Verifikasi Email Dikirimkan!",
                    style: textTheme(context)
                        .titleLarge
                        ?.copyWith(color: primaryColor(context)),
                  ),
                  16.height,
                  Text(
                    "Kami telah mengirimkan verifikasi ke alamat email",
                    style: textTheme(context).bodyMedium,
                  ),
                  16.height,
                  Obx(
                    () => Container(
                      width: Get.width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: theme(context).disabledColor)),
                      padding: EdgeInsets.all(6),
                      child: Text(
                        controller.email,
                        style: textTheme(context)
                            .titleMedium
                            ?.copyWith(color: primaryColor(context)),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(
                      () => TextButton(
                        onPressed: controller.lastVerif > 0
                            ? null
                            : () {
                                controller.setTimer();
                              },
                        child: Text(
                          "Kirim Ulang Verifikasi ${controller.lastVerif > 0 ? "(${controller.lastVerif})" : ''}",
                          style: textTheme(context)
                              .titleSmall
                              ?.copyWith(color: primaryColor(context)),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Silahkan periksa kotak masuk Anda dan ikuti langkah-langkah verifikasi untuk menyelesaikan proses pendaftaran. Klik Sign In jika anda telah melakukan verifikasi.",
                    style: textTheme(context).bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  16.height,
                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading
                          ? null
                          : () {
                              controller.signIn();
                            },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 64),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24))),
                      child: controller.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator())
                          : Text(
                              "Sign In",
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )));
  }
}
