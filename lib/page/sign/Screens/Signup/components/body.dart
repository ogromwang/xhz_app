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
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "注册",
              press: () {},
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
