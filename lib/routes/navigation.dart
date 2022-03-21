
import 'package:flutter/material.dart';

// NavigationButton 下方的导航栏
class NavigationButton extends StatefulWidget {
  const NavigationButton({Key? key}) : super(key: key);

  @override
  State<NavigationButton> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationButton> {
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
    return BottomNavigationBar(
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
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: "我的"),
      ],
    );
  }
}

// FloatingButton 浮动添加按钮
class FloatingButton extends StatelessWidget {
  const FloatingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/add');
      },
      child: const Icon(Icons.add),
    );
  }
}

