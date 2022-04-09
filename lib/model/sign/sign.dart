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
  Future signup(BuildContext context, String username, password, rePassword) async {
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

  }

}