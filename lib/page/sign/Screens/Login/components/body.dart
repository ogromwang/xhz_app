import 'package:demo_app/model/sign/sign.dart';
import 'package:demo_app/page/sign/Screens/Signup/signup_screen.dart';
import 'package:demo_app/page/sign/components/already_have_an_account_acheck.dart';
import 'package:demo_app/page/sign/components/rounded_button.dart';
import 'package:demo_app/page/sign/components/rounded_input_field.dart';
import 'package:demo_app/page/sign/components/rounded_password_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'background.dart';

class Body extends StatelessWidget {
  Body({
    Key? key,
  }) : super(key: key);

  String _username = "";
  String _password = "";
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
              "assets/icons/pig-signin.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
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
            RoundedButton(
              text: "登录",
              press: () {
                _signModel.login(context, _username, _password);
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.of(context).pushNamedAndRemoveUntil("/signup", (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
