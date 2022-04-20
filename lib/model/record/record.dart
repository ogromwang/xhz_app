import 'dart:io';

import 'package:demo_app/common/popup.dart';
import 'package:demo_app/common/widgets.dart';
import 'package:demo_app/model/common/result/common_model_result.dart';
import 'package:demo_app/model/sign/result/sign_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/request/dio.dart';

class RecordModel {

  double money = 0;
  String desc = "";
  bool isSelected = true;
  String photo = "";

  /// push
  Future push(BuildContext context) async {
    if (desc.isEmpty) {
      ToastUtil.err("简单描述一下吧.");
      return;
    }
    if (money == 0) {
      ToastUtil.err("填写一下金额吧.");
      return;
    }

    var param = {
      "share": isSelected,
      "money": money,
      "describe": desc,
    };

    if (photo.isNotEmpty) {
      var fileCompose = await ImageCompose.imageCompressAndGetFile(File(photo));
      if (fileCompose == null) {
        ToastUtil.err("图片处理失败");
        return;
      }
      param["file"]= await MultipartFile.fromFile(fileCompose.path);
    }

    var op = Options(
        sendTimeout: 60000
    );

    try {
      Loading.show(context);
      var value = await HttpUtils.post("/v1/record", data: FormData.fromMap(param), options: op);
      var result = BoolModelResult.fromJson(value);
      if (result.code == 200 && result.data) {
        // 刷新
        Navigator.pop(context, true);
      }

    } finally {
      Loading.dismiss(context);
    }

  }


}