import 'package:demo_app/model/account/result/profile.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/request/dio.dart';

class ProfileModel {

  ProfileData? data;

  /// 获取用户信息
  Future<void> get(BuildContext context) async {
    var value = await HttpUtils.get("/v1/account/profile");

    // 请求成功
    var result = ProfileResult.fromJson(value);
    if (result.code == 200) {
      data = result.data;
    } else {
      // 提示错误
    }
  }

  /// 修改头像
  Future updateProfilePicture(BuildContext context) async {

  }

}