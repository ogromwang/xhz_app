import 'package:demo_app/common/popup.dart';
import 'package:demo_app/model/common/result/common_model_result.dart';
import 'package:demo_app/model/sign/result/sign_model.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/request/dio.dart';

class SignModel {

  /// 登录
  Future login(BuildContext context, String username, password) async {
    var data = {
      "username": username,
      "password": password
    };
    var value = await HttpUtils.post("/v1/account/signin", data: data);
    var result = LoginModelResult.fromJson(value);
    if (result.code == 200 && result.data.isNotEmpty) {
      // 存储 token 跳转到
      SpUtil().setAccessToken(result.data).then((value) {
        if (value) {
          ToastUtil.err("登录成功");
          // 跳转到首页
          Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> route) => false);

        } else {
          ToastUtil.err("登录失败，请重试");
        }
      });
    }

  }

  /// 注册
  Future signup(BuildContext context, String username, String password, String rePassword) async {
    if (password.length < 5 || password.length > 12) {
      ToastUtil.err("密码长度应该在[5-12]");
      return;
    }
    if (username.length > 6) {
      ToastUtil.err("用户名不能超过[6]");
      return;
    }
    if (password != rePassword) {
      ToastUtil.err("两次密码输入不一致");
      return;
    }

    try {
      Loading.show(context);
      var data = {
        "username": username,
        "password": password,
        "rePassword": rePassword
      };
      var value = await HttpUtils.post("/v1/account/signup", data: data);
      var result = BoolModelResult.fromJson(value);
      if (result.code == 200 && result.data) {
        ToastUtil.err("注册成功，去登录");
        // 跳转到登录
        Navigator.of(context).pushNamedAndRemoveUntil("/login", (Route<dynamic> route) => false);
      }
    } finally {
      Loading.dismiss(context);
    }

  }

}