import 'package:demo_app/common/app_theme.dart';
import 'package:demo_app/page/sign/components/text_field_container.dart';
import 'package:flutter/material.dart';


class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: AppTheme.kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: AppTheme.kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
