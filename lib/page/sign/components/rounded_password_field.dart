import 'package:demo_app/common/app_theme.dart';
import 'package:demo_app/page/sign/components/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  const RoundedPasswordField({
    Key? key,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: AppTheme.kPrimaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            Icons.lock,
            color: AppTheme.kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: AppTheme.kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
