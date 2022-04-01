import 'package:demo_app/routes/navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/routes/routes.dart';
import 'package:demo_app/request/dio.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = true;
  await init();
  runApp(BootApplication());
}

Future<void> init() async {
  // 初始化本地存储类
  await SpUtil().init();
  // 初始化request类
  HttpUtils.init(
    baseUrl: "172.16.68.10",
  );
  print("全局注入");
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
