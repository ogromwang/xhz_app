import 'package:flutter/material.dart';
import 'package:demo_app/model/account/result/account.dart';
import 'package:demo_app/request/dio.dart';

class SearchFriendsListModel {
  int currentPage = 1;
  int pageSize = 2;
  String username = "";

  final AccountFriendResultData _data = AccountFriendResultData([], 0);

  get listData => _data;

  //请求数据的方法
  Future<void> getListData(BuildContext context) async {
    var params = {
      "page" : currentPage,
      "pageSize" : pageSize,
      "username": username
    };
    var value = await HttpUtils.get("v1/account/friends/find", params: params);
    print("得到的value为:$value");
    // 请求成功
    var result = AccountFriendResult.fromJson(value);
    if (result.code == 200) {
      _data.list.addAll(result.data.list);
      _data.total = result.data.total;
      currentPage++;
    } else {
      // 提示错误
    }
  }

  //上拉刷新数据的方法
  Future refreshData(BuildContext context) async {
    currentPage = 1;
    _data.list.clear();
    return getListData(context);
  }

  //加载更多数据的方法
  Future loadMoreData(BuildContext context) async {
    return getListData(context);
  }

}