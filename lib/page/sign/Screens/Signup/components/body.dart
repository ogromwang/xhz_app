import 'package:demo_app/common/toast.dart';
import 'package:demo_app/model/sign/sign.dart';
import 'package:demo_app/page/sign/Screens/Login/login_screen.dart';
import 'package:demo_app/page/sign/Screens/Signup/components/or_divider.dart';
import 'package:demo_app/page/sign/components/already_have_an_account_acheck.dart';
import 'package:demo_app/page/sign/components/rounded_button.dart';
import 'package:demo_app/page/sign/components/rounded_input_field.dart';
import 'package:demo_app/page/sign/components/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';
import 'social_icon.dart';

class Body extends StatelessWidget {
  String _username = "";
  String _password = "";
  String _rePassword = "";
  final SignModel _signModel = SignModel();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/pig-signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "用户名",
              onChanged: (value) {
                _username = value;
              },
            ),
            RoundedPasswordField(
              hintText: "密码",
              onChanged: (value) {
                _password = value;
              },
            ),
            RoundedPasswordField(
              hintText: "确认密码",
              onChanged: (value) {
                _rePassword = value;
              },
            ),
            RoundedButton(
              text: "注册",
              press: () {
                if (_password != _rePassword) {
                  ToastUtil.err("两次密码输入不一致");
                  return;
                }
                _signModel.signup(context, _username, _password, _rePassword);
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.of(context).pushNamedAndRemoveUntil("/login", (Route<dynamic> route) => false);
              },
            ),

          ],
        ),
      ),
    );
  }
}
