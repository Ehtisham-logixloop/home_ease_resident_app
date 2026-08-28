import 'package:flutter/material.dart';
import 'package:home_ease_resident_app/core/utils/routes/routes_name.dart';
import '../../../modules/auth/views/boarding_screen.dart';
import '../../../modules/auth/views/forgot_screen.dart';
import '../../../modules/auth/views/login_screen.dart';
import '../../../modules/auth/views/pin_screen.dart';
import '../../../modules/auth/views/set_password.dart';
import '../../../modules/auth/views/signup_screen.dart';
import '../../../modules/booking/views/booking_screen.dart';
import '../../../modules/create_request/views/map_field_screen.dart';
import '../../../modules/home/views/home_screen.dart';
import '../../../modules/message/views/message_screen.dart';
import '../../../modules/message/views/chat_screen.dart';
import '../../../modules/message/views/notification_screen.dart';
import '../../../modules/profile/views/profile_screen.dart';
import '../../../modules/profile/views/edit_profile_screen.dart';
import '../../../modules/splash/views/splash_screen.dart';


class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RoutesName.splash:
        return MaterialPageRoute(builder:(BuildContext context)=> SplashScreen());
      case RoutesName.boarding:
        return MaterialPageRoute(builder:(BuildContext context)=> BoardingScreen());
      case RoutesName.login:
        return MaterialPageRoute(builder:(BuildContext context)=> LoginScreen());
      case RoutesName.signup:
        return MaterialPageRoute(builder:(BuildContext context)=> SignupScreen());
      case RoutesName.forgot:
        return MaterialPageRoute(builder:(BuildContext context)=> ForgetScreen());
      case RoutesName.password:
      case RoutesName.setPassword:
        return MaterialPageRoute(builder:(BuildContext context)=> SetPassword());
      case RoutesName.pin:
        return MaterialPageRoute(builder:(BuildContext context)=> PinScreen());
      // case RoutesName.request:
      //   return MaterialPageRoute(builder:(BuildContext context)=> CreateRequestScreen());
      case RoutesName.map:
        return MaterialPageRoute(builder:(BuildContext context)=> MapFieldScreen());
      case RoutesName.home:
        return MaterialPageRoute(builder:(BuildContext context)=> HomeScreen());
      case RoutesName.booking:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (BuildContext context) => BookingScreen(
              provider: args['provider'],
              categoryName: args['categoryName'],
            ),
          );
        }
        return MaterialPageRoute(builder:(BuildContext context)=> BookingScreen());
      case RoutesName.message:
        return MaterialPageRoute(builder:(BuildContext context)=> MessageScreen());
      case RoutesName.notifications:
        return MaterialPageRoute(builder:(BuildContext context)=> const NotificationScreen());
      case RoutesName.profile:
        return MaterialPageRoute(builder:(BuildContext context)=> ProfileScreen());
      case RoutesName.editProfile:
        return MaterialPageRoute(builder:(BuildContext context)=> EditProfileScreen());
      case RoutesName.chat:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder:(BuildContext context)=> ChatScreen(
            name: args['name'],
            image: args['image'],
            role: args['role'],
            bookingId: args['bookingId'],
            providerId: args['providerId'],
            userId: args['userId'],
          ),
        );
      default:
        return MaterialPageRoute(builder: (_){
          return Scaffold(
          body: Center(
          child: Text('No route defined'),
          ),
          );
    });
    }
  }
}
