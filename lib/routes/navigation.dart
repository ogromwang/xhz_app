
import 'package:demo_app/page/add/push_record.dart';
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
class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        Navigator.push<dynamic>(
          context,
          MaterialPageRoute<dynamic>(builder: (BuildContext context) => PushRecordScreen(), fullscreenDialog: true),
        );

        // Navigator.pushNamed(context, '/add');
      },
      child: const Icon(Icons.add, color: Colors.white,),
    );
  }
}

// FloatingButton 浮动添加按钮
class FloatingAddFriendButton extends StatelessWidget {
  const FloatingAddFriendButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/find');
      },
      child: const Icon(Icons.search, color: Colors.white,),
    );
  }
}
