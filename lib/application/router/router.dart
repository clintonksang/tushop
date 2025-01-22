import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:tushop/domains/models/task_model.dart';
import 'package:tushop/presentation/pages/home/home.dart';

import '../../presentation/pages/authentication/enterKYCscreen.dart';
import '../../presentation/pages/authentication/login.dart';
import '../../presentation/pages/authentication/otp_screen.dart';
import '../../presentation/pages/authentication/phonescreen.dart';
import '../../presentation/pages/home/task_form.dart';
import '../../presentation/pages/splash/launcher.dart';

class AppRouter {
  static const String initial = "/";
  static const String phone = "/phone";
  static const String login = "/login";
  static const String otpscreen = "/otpscreen";
  static const String kycpage = "/kycpage";
  static const String home = "/home";
  static const String taskForm = "/viewTask";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    Logger logger = Logger();
    logger.w("Route Name:\n${settings.name}");

    switch (settings.name) {
      case initial:
        return _slideRoute(Launcher());
      case home:
        return _slideRoute(Home());
      case phone:
        return _slideRoute(PhoneScreen());
      case login:
        return _slideRoute(Login());

      case otpscreen:
        return _slideRoute(OtpScreen(verificationCode: args as String));

      case kycpage:
        return _slideRoute(EnterKYCPage());
      case taskForm:
        return _slideRoute(
          TaskFormPage(
            taskModel: args as TaskModel?,
            
          ),
        );
      default:
        return _slideRoute(Launcher());
    }
  }

  static Route _slideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }
}
