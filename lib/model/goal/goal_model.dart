import 'package:demo_app/common/popup.dart';
import 'package:demo_app/model/common/result/common_model_result.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/request/dio.dart';

import 'result/goal_result_model.dart';


class GoalModel {

  List<OneGoal> data = [];

  //请求数据的方法
  Future<void> getGoal(BuildContext context) async {
    var value = await HttpUtils.get("v1/goal");

    GoalResultModel resultModel = GoalResultModel.fromJson(value);
    if (resultModel.code == 200) {
      data = resultModel.data;
    }
  }

  //请求数据的方法
  Future<void> setGoal(BuildContext context, OneGoal update) async {

    var params = {
      "id" : update.id,
      "money": update.goal,
      "account_ids": update.accountIds,
      "type": update.type
    };

    try {
      Loading.show(context);
      var value = await HttpUtils.post("v1/goal", params: params);
      BoolModelResult result = BoolModelResult.fromJson(value);
      if (result.code == 200) {
        getGoal(context);
        return;
      }

    } finally {
      Loading.dismiss(context);
    }

  }

}