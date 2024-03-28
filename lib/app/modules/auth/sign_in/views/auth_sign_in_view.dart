import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:godsseo/app/data/helpers/assets.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/routes/app_pages.dart';
import 'package:nb_utils/nb_utils.dart';

import '../controllers/auth_sign_in_controller.dart';

class AuthSignInView extends GetResponsiveView<AuthSignInController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('AuthSignInView'),
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
                            "Login",
                            style: textTheme(context)
                                .headlineMedium
                                ?.copyWith(color: primaryColor(context)),
                          ),
                          16.height,
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: controller.emailC,
                            decoration: InputDecoration(
                                labelText: "Email",
                                icon: Icon(Icons.email_rounded)),
                            validator: (value) =>
                                (value?.validateEmail() ?? false)
                                    ? null
                                    : "Email is not valid",
                          ),
                          16.height,
                          Obx(
                            () => TextFormField(
                              controller: controller.passwordC,
                              obscureText: !controller.showPassword,
                              validator: (value) => value.isEmptyOrNull
                                  ? 'This field is required!'
                                  : null,
                              decoration: InputDecoration(
                                  labelText: "Password",
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
                          Container(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              child: Text("Forgot Password?"),
                              onPressed: () {
                                Get.toNamed(Routes.AUTH_FORGET_PASSWORD);
                              },
                            ),
                          ),
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
                                          controller.signIn();
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(24))),
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
                          ),
                          16.height,
                          TextButton(
                            onPressed: () {
                              Get.offNamed(Routes.AUTH_SIGN_UP);
                            },
                            child: Text(
                              "Didn't have an account? \nRegister Here!",
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
      ),
    );
  }
}
