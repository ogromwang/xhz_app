import 'package:demo_app/page/account.dart';
import 'package:demo_app/page/friends/find_friends.dart';
import 'package:demo_app/page/add/add.dart';

class Routes {

  static var data = {
    '/account': (context) => Account(),
    '/add' : (context) => AddWidget(),
    '/find' : (context) => FindFriends(),
  };

}

