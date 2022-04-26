import 'package:flutter/services.dart';

class MyNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.001;

  ///允许的小数位数，-1代表不限制位数
  int digit;
  Function? numberPointFunc;

  MyNumberTextInputFormatter({this.digit = -1, this.numberPointFunc});

  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  ///获取目前的小数位数
  static int getValueDigit(String value) {
    return getDigit(value).length;
  }

  ///获取目前的小数位数
  static String getDigit(String value) {
    if (value.contains(".")) {
      return value.split(".")[1];
    } else {
      return "";
    }
  }

  static String getNumber(String value) {
    var val = value;
    if (value.contains(".")) {
      val = value.split(".")[0];
    }
    return val;
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;

    if ((value.contains(".."))) {
      if (numberPointFunc != null) {
        numberPointFunc!();
      }
    }

    var number = getNumber(value);
    if (number.length > 6) {
      var digit = getDigit(value);
      var suffix = "";
      if (digit.isNotEmpty) {
        suffix = "." + digit;
      }

      value = number.substring(0, 6) + suffix;
      selectionIndex = value.length;
    }
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if (value == "-") {
      value = "-";
      selectionIndex++;
    } else if (value != "" && value != defaultDouble.toString() && strToFloat(value, defaultDouble) == defaultDouble ||
        getValueDigit(value) > digit) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
