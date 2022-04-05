import 'package:demo_app/common/app_theme.dart';
import 'package:flutter/material.dart';


class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final VoidCallback? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "还没有账户 ? " : "已经有账户 ? ",
          style: TextStyle(color: AppTheme.kPrimaryColor),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "去注册" : "去登录",
            style: TextStyle(
              color: AppTheme.kPrimaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
