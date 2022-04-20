import 'package:flutter/material.dart';
import 'package:demo_app/model/account/result/account.dart';
import 'package:demo_app/request/dio.dart';


class GoalModel {

  //请求数据的方法
  Future<void> getGoal(BuildContext context) async {

    var value = await HttpUtils.get("v1/record/all", params: );
  }


}