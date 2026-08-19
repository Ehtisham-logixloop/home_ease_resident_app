part of 'app_pages.dart';

abstract class Routes {
  static const splash = _Paths.splash;
  static const boarding = _Paths.boarding;
  static const login = _Paths.login;
  static const signup = _Paths.signup;
  static const pin = _Paths.pin;
  static const forgot = _Paths.forgot;
  static const setPassword = _Paths.setPassword;
  static const home = _Paths.home;
  static const map = _Paths.map;
  static const myRequest = _Paths.myRequest;
  static const booking = _Paths.booking;
  static const message = _Paths.message;
  static const profile = _Paths.profile;
}

abstract class _Paths {
  static const splash = '/splash';
  static const boarding = '/boarding';
  static const login = '/login';
  static const signup = '/signup';
  static const pin = '/pin';
  static const forgot = '/forgot';
  static const setPassword = '/set-password';
  static const home = '/home';
  static const createRequest = '/create-request';
  static const map = '/map';
  static const myRequest = '/my-request';
  static const booking = '/booking';
  static const message = '/message';
  static const profile = '/profile';
}
