import 'package:demo_app/common/app_theme.dart';
import 'package:demo_app/custom_drawer/drawer_user_controller.dart';
import 'package:demo_app/custom_drawer/home_drawer.dart';
import 'package:demo_app/page/home/home_list.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/page/friends/friends_list_1.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = HotelHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexData) {
              changeIndex(drawerIndexData);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexData) {
    if (drawerIndex != drawerIndexData) {
      drawerIndex = drawerIndexData;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = HotelHomeScreen();
          });
          break;
        case DrawerIndex.Friends:
          setState(() {
            screenView = MyFriendsList();
          });
          break;
        case DrawerIndex.About:

          break;

        default:
          break;
      }
    }
  }
}
