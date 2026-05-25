import 'package:get/get.dart';

import '../middleware/auth_middleware.dart';
import '../modules/create_journal/bindings/create_journal_binding.dart';
import '../modules/create_journal/views/create_journal_view.dart';
import '../modules/calendar/bindings/calendar_binding.dart';
import '../modules/calendar/views/calendar_view.dart';
import '../modules/detail_journal/bindings/detail_journal_binding.dart';
import '../modules/detail_journal/views/detail_journal_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/mood/bindings/mood_binding.dart';
import '../modules/mood/views/mood_view.dart';
import '../modules/otp_reset/bindings/otp_reset_binding.dart';
import '../modules/otp_reset/views/otp_reset_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP_RESET,
      page: () => const OtpResetView(),
      binding: OtpResetBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CREATE_JOURNAL,
      page: () => const CreateJournalView(),
      binding: CreateJournalBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.DETAIL_JOURNAL,
      page: () => const DetailJournalView(),
      binding: DetailJournalBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.MOOD,
      page: () => const MoodView(),
      binding: MoodBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.CALENDAR,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
