import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/email_confirmation/bindings/auth_email_confirmation_binding.dart';
import '../modules/auth/email_confirmation/views/auth_email_confirmation_view.dart';
import '../modules/auth/forget_password/bindings/auth_forget_password_binding.dart';
import '../modules/auth/forget_password/views/auth_forget_password_view.dart';
import '../modules/auth/sign_in/bindings/auth_sign_in_binding.dart';
import '../modules/auth/sign_in/views/auth_sign_in_view.dart';
import '../modules/auth/sign_up/bindings/auth_sign_up_binding.dart';
import '../modules/auth/sign_up/views/auth_sign_up_view.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_admin/bindings/home_admin_binding.dart';
import '../modules/home_admin/views/home_admin_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/users/bindings/users_binding.dart';
import '../modules/users/detail/bindings/users_detail_binding.dart';
import '../modules/users/detail/views/users_detail_view.dart';
import '../modules/users/form/bindings/users_form_binding.dart';
import '../modules/users/form/views/users_form_view.dart';
import '../modules/users/views/users_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => AuthView(),
      binding: AuthBinding(),
      children: [
        GetPage(
          name: _Paths.SIGN_IN,
          page: () => AuthSignInView(),
          binding: AuthSignInBinding(),
        ),
        GetPage(
          name: _Paths.SIGN_UP,
          page: () => AuthSignUpView(),
          binding: AuthSignUpBinding(),
        ),
        GetPage(
          name: _Paths.FORGET_PASSWORD,
          page: () => AuthForgetPasswordView(),
          binding: AuthForgetPasswordBinding(),
        ),
        GetPage(
          name: _Paths.EMAIL_CONFIRMATION,
          page: () => const AuthEmailConfirmationView(),
          binding: AuthEmailConfirmationBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.HOME_ADMIN,
      page: () => const HomeAdminView(),
      binding: HomeAdminBinding(),
    ),
    GetPage(
      name: _Paths.USERS,
      page: () => const UsersView(),
      binding: UsersBinding(),
      children: [
        GetPage(
          name: _Paths.FORM,
          page: () => const UsersFormView(),
          binding: UsersFormBinding(),
        ),
        GetPage(
          name: _Paths.DETAIL,
          page: () => const UsersDetailView(),
          binding: UsersDetailBinding(),
        ),
      ],
    ),
  ];
}
