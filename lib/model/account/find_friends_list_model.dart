import 'package:flutter/material.dart';
import 'package:demo_app/model/account/result/account.dart';
import 'package:demo_app/request/dio.dart';

class SearchFriendsListModel {
  int currentPage = 1;
  int pageSize = 20;
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

  Future<void> applyAddFriend(BuildContext context, int friendId) async {
    var data = {
      "id": friendId
    };
    var value = await HttpUtils.post("/v1/account/friends/apply", data: data);
    print("申请添加好友, 好友ID: $friendId; 结果: $value");
    // {code: 200, data: true, error: }
    Navigator.maybePop(context);
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