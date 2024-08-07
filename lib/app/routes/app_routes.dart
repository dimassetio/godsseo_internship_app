part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const AUTH = _Paths.AUTH;
  static const AUTH_SIGN_IN = _Paths.AUTH + _Paths.SIGN_IN;
  static const AUTH_SIGN_UP = _Paths.AUTH + _Paths.SIGN_UP;
  static const AUTH_FORGET_PASSWORD = _Paths.AUTH + _Paths.FORGET_PASSWORD;
  static const AUTH_EMAIL_CONFIRMATION =
      _Paths.AUTH + _Paths.EMAIL_CONFIRMATION;
  static const PROFILE = _Paths.PROFILE;
  static const HOME_ADMIN = _Paths.HOME_ADMIN;
  static const USERS = _Paths.USERS;
  static const USERS_FORM = _Paths.USERS + _Paths.FORM;
  static const USERS_DETAIL = _Paths.USERS + _Paths.DETAIL;
  static const PRESENSI_DETAIL = _Paths.PRESENSI + _Paths.DETAIL;
  static const PRESENSI_INDEX = _Paths.PRESENSI + _Paths.INDEX;
  static const PRESENSI_ADMIN = _Paths.PRESENSI + _Paths.ADMIN;
  static const PENGATURAN = _Paths.PENGATURAN;
  static const DAYOFF = _Paths.DAYOFF;
  static const PRESENSI_ADMIN_HISTORY = _Paths.PRESENSI + _Paths.ADMIN_HISTORY;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const AUTH = '/auth';
  static const SIGN_IN = '/sign-in';
  static const SIGN_UP = '/sign-up';
  static const FORGET_PASSWORD = '/forget-password';
  static const EMAIL_CONFIRMATION = '/email-confirmation';
  static const PROFILE = '/profile';
  static const HOME_ADMIN = '/home-admin';
  static const USERS = '/users';
  static const FORM = '/form';
  static const DETAIL = '/detail';
  static const PRESENSI = '/presensi';
  static const INDEX = '/index';
  static const ADMIN = '/admin';
  static const PENGATURAN = '/pengaturan';
  static const DAYOFF = '/dayoff';
  static const ADMIN_HISTORY = '/admin-history';
}
