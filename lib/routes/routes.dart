import 'package:demo_app/page/account.dart';
import 'package:demo_app/page/friends/find_friends.dart';
import 'package:demo_app/page/sign/Screens/Login/login_screen.dart';
import 'package:demo_app/page/sign/Screens/Signup/signup_screen.dart';
import 'package:flutter/material.dart';

import 'navigation_home_screen.dart';

class Routes {

  static var data = {
    '/account': (context) => Account(),
    '/find' : (context) => FindFriends(),
    '/login' : (context) => LoginScreen(),
    '/signup' : (context) => SignUpScreen(),
    '/home' : (context) {
      return Scaffold(
        body: NavigationHomeScreen(),
      );
    }
  };

}

