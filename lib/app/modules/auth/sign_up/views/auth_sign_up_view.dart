import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/assets.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/helpers/validator.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/auth_sign_up_controller.dart';

class AuthSignUpView extends GetResponsiveView<AuthSignUpController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // appBar: AppBar(
        //   title: const Text('AuthSignUpView'),
        //   centerTitle: true,
        // ),
        body: Container(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Center(
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  svg_logo,
                  height: 100,
                ),
                16.height,
                Card(
                  margin: EdgeInsets.all(20),
                  color: bgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          "Register".tr,
                          style: textTheme(context)
                              .headlineMedium
                              ?.copyWith(color: primaryColor(context)),
                        ),
                        16.height,
                        TextFormField(
                          controller: controller.nameC,
                          validator: requiredValidator,
                          decoration: InputDecoration(
                              labelText: "Name".tr,
                              icon: Icon(Icons.account_circle_rounded)),
                        ),
                        8.height,
                        TextFormField(
                          controller: controller.emailC,
                          validator: emailValidator,
                          decoration: InputDecoration(
                              labelText: "Email".tr,
                              icon: Icon(Icons.email_rounded)),
                        ),
                        8.height,
                        Obx(
                          () => TextFormField(
                            controller: controller.passwordC,
                            obscureText: !controller.showPassword,
                            validator: (value) => minLengthValidator(value, 6),
                            decoration: InputDecoration(
                                labelText: "Password".tr,
                                icon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.togglePasword();
                                    },
                                    icon: Icon(controller.showPassword
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded))),
                          ),
                        ),
                        8.height,
                        Obx(
                          () => TextFormField(
                            controller: controller.confirmPasswordC,
                            obscureText: !controller.showPassword,
                            validator: (value) =>
                                controller.confirmPasswordC.text ==
                                        controller.passwordC.text
                                    ? null
                                    : "Password tidak sama!".tr,
                            decoration: InputDecoration(
                                labelText: "Konfirmasi Password".tr,
                                icon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      controller.togglePasword();
                                    },
                                    icon: Icon(controller.showPassword
                                        ? Icons.visibility_off_rounded
                                        : Icons.visibility_rounded))),
                          ),
                        ),
                        16.height,
                        Container(
                          width: Get.width,
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: controller.isLoading
                                  ? null
                                  : () {
                                      if (controller.formKey.currentState
                                              ?.validate() ??
                                          false) {
                                        controller.signUp();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24))),
                              child: controller.isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator())
                                  : Text(
                                      "Sign Up".tr,
                                    ),
                            ),
                          ),
                        ),
                        16.height,
                        TextButton(
                          onPressed: () {
                            Get.offNamed(Routes.AUTH_SIGN_IN);
                          },
                          child: Text(
                            "Sudah punya akun?".tr,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
