import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:godsseo/app/data/helpers/firebase_options.dart';
import 'package:godsseo/app/data/helpers/languages.dart';
import 'package:godsseo/app/data/helpers/themes.dart';
import 'package:godsseo/app/data/models/user_model.dart';
import 'package:godsseo/app/modules/auth/controllers/auth_controller.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LanguageTranslation.localeList.forEach(
    (element) async => await initializeDateFormatting(element.countryCode),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var authController = Get.put(AuthController(), permanent: true);
  await authController.getActiveUser();
  runApp(
    GetMaterialApp(
      title: "Godsseo-App",
      debugShowCheckedModeBanner: false,
      translations: LanguageTranslation(),
      locale: Get.locale ?? LanguageTranslation.localeID,
      initialRoute: authController.isLoggedIn
          ? authC.user.hasRole(Role.administrator)
              ? Routes.HOME_ADMIN
              : Routes.HOME
          : Routes.AUTH_SIGN_IN,
      getPages: AppPages.routes,
      theme: mainTheme,
    ),
  );
}
