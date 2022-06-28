import 'dart:io';

import 'package:demo_app/common/popup.dart';
import 'package:demo_app/common/widgets.dart';
import 'package:demo_app/model/account/result/profile.dart';
import 'package:demo_app/model/common/result/common_model_result.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/request/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http_parser/http_parser.dart';

class ProfileModel {

  ProfileData? data;
  final imagePicker = ImagePicker();

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
  Future<void> updateProfilePicture(BuildContext context) async {
    final pickFile = await imagePicker.getImage(source: ImageSource.gallery);

    MultipartFile multi;
    if (pickFile != null) {
      if (kIsWeb) {
        var bytes = await pickFile.readAsBytes();
        multi = MultipartFile.fromBytes(bytes.toList(), filename: 'test.jpg',contentType: MediaType('image', 'jpeg'));

      } else {
        var composeImage = await ImageCompose.imageCompressAndGetFile(File(pickFile.path));
        String path = pickFile.path;
        if (composeImage != null) {
          path = composeImage.path;
        }
        multi = await MultipartFile.fromFile(path);
      }

      var data = FormData.fromMap({
        "file": multi
      });

      var op = Options(
        sendTimeout: 60000
      );

      try {
        Loading.show(context);
        var value = await HttpUtils.put("/v1/account/profile/picture", data: data, options: op);
        var result = BoolModelResult.fromJson(value);
        return;

      } finally {
        Loading.dismiss(context);
      }
    }
  }
}