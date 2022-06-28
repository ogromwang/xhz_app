import 'dart:io';

import 'package:demo_app/common/popup.dart';
import 'package:demo_app/common/widgets.dart';
import 'package:demo_app/model/common/result/common_model_result.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/request/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class RecordModel {

  double money = 0;
  String desc = "";
  bool isSelected = true;
  String photo = "";
  late PickedFile pickedFile;

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
      if (kIsWeb) {
        var bytes = await pickedFile.readAsBytes();
        param["file"]= MultipartFile.fromBytes(bytes.toList(), filename: 'test.jpg',contentType: MediaType('image', 'jpeg'));

      } else {
        var fileCompose = await ImageCompose.imageCompressAndGetFile(File(photo));
        if (fileCompose == null) {
          ToastUtil.err("图片处理失败");
          return;
        }
        param["file"]= await MultipartFile.fromFile(fileCompose.path);
      }

    }

    var op = Options(
        contentType: 'multipart/form-data',
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