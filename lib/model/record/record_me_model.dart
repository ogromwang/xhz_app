import 'package:flutter/material.dart';
import 'package:demo_app/model/account/result/account.dart';
import 'package:demo_app/request/dio.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";

import 'result/record_result.dart';

class RecordMeModel {
  int currentPage = 1;
  int pageSize = 20; //每次分页加载的条数

  final RecordResult _result = RecordResult(code: 0, data: Data(list: [], more: false), error: "");

  Map<String, List<Item>> _group = {};
  List<String> _groupKeys = [];

  Data get data => _result.data;

  Map<String, List<Item>> get group => _group;
  List<String> get groupKeys => _groupKeys;

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

      toGroup();

      _result.data.more = result.data.more;
      currentPage++;
    } else {
      // 提示错误
    }
  }

  void toGroup() {
    _group.clear();
    _groupKeys.clear();
    var monthFormat = DateFormat('yy-MM');
    var groupByDate = groupBy(_result.data.list, (Item obj) => monthFormat.format(obj.createdAt));
    _group = groupByDate;

    _group.forEach((key, value) {
      _groupKeys.add(key);
    });
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