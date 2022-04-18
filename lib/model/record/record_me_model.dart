import 'package:flutter/material.dart';
import 'package:demo_app/model/account/result/account.dart';
import 'package:demo_app/request/dio.dart';

import 'result/record_result.dart';

class RecordMeModel {
  int currentPage = 1;
  int pageSize = 20; //每次分页加载的条数

  final RecordResult _result = RecordResult(code: 0, data: Data(list: [], more: false), error: "");

  Data get data => _result.data;

  //请求数据的方法
  Future<void> getListData(BuildContext context) async {
    var params = {
      "page" : currentPage,
      "pageSize" : pageSize
    };
    var value = await HttpUtils.get("v1/record/me", params: params);

    // 请求成功
    var result = RecordResult.fromJson(value);
    if (result.code == 200) {
      _result.data.list.addAll(result.data.list);
      _result.data.more = result.data.more;
      currentPage++;
    } else {
      // 提示错误
    }
  }

  //上拉刷新数据的方法
  Future refreshData(BuildContext context) async {
    currentPage = 1;
    _result.data.list.clear();
    return getListData(context);
  }

  //加载更多数据的方法
  Future loadMoreData(BuildContext context) async {
    return getListData(context);
  }

}