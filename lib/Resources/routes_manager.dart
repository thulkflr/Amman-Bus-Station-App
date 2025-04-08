// import 'package:flutter/material.dart';
// import 'package:testapp/Presentation/Forgot_Password/ForgotPasswordView/forgot_password_screen.dart';
// import 'package:testapp/Presentation/Login/View/login_screen.dart';
// import 'package:testapp/Presentation/Main/main_screen.dart';
// import 'package:testapp/Presentation/On_Bording/on_boarding_view.dart';
// import 'package:testapp/Presentation/Register/RigesterView/register_screen.dart';
// import 'package:testapp/Presentation/Resources/strings_manager.dart';
// import 'package:testapp/Presentation/Splash/splash_screen.dart';
// import 'package:testapp/Presentation/Store_Details/store_details_view.dart';
//
// import '../../Application/di.dart';
//
// class Routes {
//   static const String splashRoute = "/";
//   static const String loginRoute = "/login";
//   static const String registerRoute = "/register";
//   static const String onBoardRoute = "/onBoarding";
//   static const String forgotRoute = "/forgotPassword";
//   static const String mainRoute = "/main";
//   static const String storeDetailsRoute = "/storeDetails";
// }
//
// class RouteGenerator {
//   static Route<dynamic> getRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case Routes.splashRoute:
//         return MaterialPageRoute(builder: (_) => const Splash_Screen());
//
//       case Routes.loginRoute:
//         initLoginModule();
//         return MaterialPageRoute(builder: (_) => const Login_Screen());
//
//       case Routes.registerRoute:
//         initRegisterModule();
//         return MaterialPageRoute(builder: (_) => const RegisterScreen());
//
//       case Routes.onBoardRoute:
//         return MaterialPageRoute(builder: (_) => const On_Boarding_View());
//
//       case Routes.forgotRoute:
//         initForgotPasswordModule();
//         return MaterialPageRoute(
//             builder: (_) => const Forgot_Password_Screen());
//
//       case Routes.mainRoute:
//         initHomeModule();
//         return MaterialPageRoute(builder: (_) => const MainScreen());
//
//       case Routes.storeDetailsRoute:
//         return MaterialPageRoute(builder: (_) => const Store_Details_View());
//
//       default:
//         return unDefinedRoute();
//     }
//   }
//
//   static Route<dynamic> unDefinedRoute() {
//     return MaterialPageRoute(
//         builder: (_) => Scaffold(
//               appBar: AppBar(
//                 title: const Text(StringsManager.noRouteFound),
//               ),
//               body: const Center(
//                 child: Text(StringsManager.noRouteFound),
//               ),
//             ));
//   }
// }
