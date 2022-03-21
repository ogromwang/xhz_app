import 'package:flutter/material.dart';
import 'package:demo_app/routes/routes.dart';
import 'package:demo_app/common/fonts.dart';
import 'package:demo_app/page/home/hotel_home_screen.dart';

void main() {
  runApp(Demo());
}

class Demo extends StatelessWidget {
  Demo({Key? key}) : super(key: key);
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "小花",
      routes: Routes.data,
      home: HomeWidget()
    );
  }
}


class HomeWidget extends StatefulWidget {

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int currentIndex = 0;

  // 跳转
  void navigator(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/account');
      currentIndex = 0;
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HotelHomeScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            navigator(index);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "首页",

          ),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: "我的"),
        ],

      ),
    );
  }
}
