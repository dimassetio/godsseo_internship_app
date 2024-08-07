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
import '../modules/dayoff/bindings/dayoff_binding.dart';
import '../modules/dayoff/views/dayoff_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_admin/bindings/home_admin_binding.dart';
import '../modules/home_admin/views/home_admin_view.dart';
import '../modules/pengaturan/bindings/pengaturan_binding.dart';
import '../modules/pengaturan/views/pengaturan_view.dart';
import '../modules/presensi/admin/bindings/presensi_admin_binding.dart';
import '../modules/presensi/admin/views/presensi_admin_view.dart';
import '../modules/presensi/admin_history/bindings/presensi_admin_history_binding.dart';
import '../modules/presensi/admin_history/views/presensi_admin_history_view.dart';
import '../modules/presensi/detail/bindings/presensi_detail_binding.dart';
import '../modules/presensi/detail/views/presensi_detail_view.dart';
import '../modules/presensi/index/bindings/presensi_index_binding.dart';
import '../modules/presensi/index/views/presensi_index_view.dart';
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
    GetPage(
        name: _Paths.PRESENSI,
        page: () => const PresensiIndexView(),
        binding: PresensiIndexBinding(),
        children: [
          GetPage(
            name: _Paths.INDEX,
            page: () => const PresensiIndexView(),
            binding: PresensiIndexBinding(),
          ),
          GetPage(
            name: _Paths.DETAIL,
            page: () => const PresensiDetailView(),
            binding: PresensiDetailBinding(),
          ),
          GetPage(
            name: _Paths.ADMIN,
            page: () => const PresensiAdminView(),
            binding: PresensiAdminBinding(),
          ),
          GetPage(
            name: _Paths.ADMIN_HISTORY,
            page: () => const PresensiAdminHistoryView(),
            binding: PresensiAdminHistoryBinding(),
          ),
        ]),
    GetPage(
      name: _Paths.PENGATURAN,
      page: () => const PengaturanView(),
      binding: PengaturanBinding(),
    ),
    GetPage(
      name: _Paths.DAYOFF,
      page: () => const DayoffView(),
      binding: DayoffBinding(),
    ),
  ];
}
