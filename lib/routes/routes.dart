import 'package:demo_app/page/account.dart';
import 'package:demo_app/page/friends/find_friends.dart';
import 'package:demo_app/page/add/add.dart';
import 'package:demo_app/page/sign/Screens/Login/login_screen.dart';
import 'package:demo_app/page/sign/Screens/Signup/signup_screen.dart';

class Routes {

  static var data = {
    '/account': (context) => Account(),
    '/add' : (context) => AddWidget(),
    '/find' : (context) => FindFriends(),
    '/login' : (context) => LoginScreen(),
    '/signup' : (context) => SignUpScreen(),
  };

}

