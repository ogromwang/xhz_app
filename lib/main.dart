import 'package:demo_app/routes/navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/routes/routes.dart';
import 'package:demo_app/request/dio.dart';


void main() {
  HttpUtils.init(baseUrl: "172.16.68.10");
  runApp(BootApplication());
}

class BootApplication extends StatelessWidget {
  BootApplication({Key? key}) : super(key: key);
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "xhz", debugShowCheckedModeBanner: false, routes: Routes.data, home: HomeWidget());
  }
}

class HomeWidget extends StatefulWidget {
  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationHomeScreen(),
      // floatingActionButton: const FloatingButton(),
      // bottomNavigationBar: const NavigationButton()
    );
  }
}
