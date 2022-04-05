import 'dart:async';

import 'package:demo_app/common/app_theme.dart';
import 'package:demo_app/common/widgets.dart';
import 'package:demo_app/model/account/my_apply_friends_list_model.dart';
import 'package:demo_app/model/account/my_friends_list_model.dart';
import 'package:demo_app/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class Controllers {
  EasyRefreshController _controller = EasyRefreshController();
  ScrollController _scrollController = ScrollController();
}

class MyFriendsList extends StatefulWidget {
  const MyFriendsList({Key? key}) : super(key: key);

  @override
  _MyFriendsListState createState() => _MyFriendsListState();
}

class _MyFriendsListState extends State<MyFriendsList> {
  late Controllers _controller1 = Controllers();
  late Controllers _controller2 = Controllers();
  late EasyRefreshController _controller;
  late ScrollController _scrollController;

  var stateModel = FriendsListModel();
  var applyFriendsModel = ApplyFriendsListModel();

  String _currChose = "";
  int _currIndex = 0;
  static const List<String> _switchList = ["我的好友", "申请列表"];

  // 控制结束
  bool _enableControlFinish = false;

  // 是否开启刷新
  bool _enableRefresh = true;

  // 是否开启加载
  bool _enableLoad = true;

  @override
  void initState() {
    super.initState();
    _currChose = _switchList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HomeAppTheme.buildLightTheme(),
      child: _scaffold(context),
    );
  }

  Widget _getItem(BuildContext context, int index, dynamic item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              child: SizedBox(
                height: 60,
                width: 60,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(40.0)),
                  child: Image.network('http://${item.profilePicture}', fit: BoxFit.cover),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: Text(item.username, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        Divider()
      ]),
    );
  }

  /// 内容
  Widget _scaffold(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingAddFriendButton(),
        body: Column(children: <Widget>[
          getAppBarUI(),
          Expanded(
              child: IndexedStack(
            index: _currIndex,
            children: [_myFriends(context), _myApplyFriends(context)],
          ))
        ]));
  }

  /// 我的好友
  Widget _myFriends(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: EasyRefresh.custom(
        firstRefresh: true,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        taskIndependence: false,
        controller: _controller1._controller,
        scrollController: _controller1._scrollController,
        reverse: false,
        scrollDirection: Axis.vertical,
        topBouncing: true,
        bottomBouncing: true,
        firstRefreshWidget: Container(
          width: double.infinity,
          height: double.infinity,
          child: const Center(child: Text("loading...")),
        ),
        header: BallPulseHeader(),
        footer: BallPulseFooter(),
        onRefresh: _enableRefresh
            ? () async {
                stateModel.refreshData(context).then((value) {
                  if (mounted) {
                    setState(() {
                      stateModel = stateModel;
                    });
                    if (!_enableControlFinish) {
                      _controller1._controller.resetLoadState();
                      _controller1._controller.finishRefresh();
                    }
                  }
                });
              }
            : null,
        onLoad: _enableLoad
            ? () async {
                stateModel.loadMoreData(context).then((value) {
                  if (mounted) {
                    setState(() {
                      stateModel = stateModel;
                    });
                    if (!_enableControlFinish) {
                      _controller1._controller.finishLoad(noMore: stateModel.listData.list.length >= stateModel.listData.total);
                    }
                  }
                });
              }
            : null,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var item = stateModel.listData.list[index];
                return _getItem(context, index, item);
              },
              childCount: stateModel.listData.list.length,
            ),
          ),
        ],
      ),
    );
  }

  /// 申请列表
  Widget _myApplyFriends(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: EasyRefresh.custom(
        firstRefresh: true,
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        taskIndependence: false,
        controller: _controller2._controller,
        scrollController: _controller2._scrollController,
        reverse: false,
        scrollDirection: Axis.vertical,
        topBouncing: true,
        bottomBouncing: true,
        firstRefreshWidget: Container(
          width: double.infinity,
          height: double.infinity,
          child: const Center(child: Text("loading...")),
        ),
        header: BallPulseHeader(),
        footer: BallPulseFooter(),
        onRefresh: _enableRefresh
            ? () async {
                applyFriendsModel.refreshData(context).then((value) {
                  if (mounted) {
                    setState(() {
                      applyFriendsModel = applyFriendsModel;
                    });
                    if (!_enableControlFinish) {
                      _controller2._controller.resetLoadState();
                      _controller2._controller.finishRefresh();
                    }
                  }
                });
              }
            : null,
        onLoad: _enableLoad
            ? () async {
                applyFriendsModel.loadMoreData(context).then((value) {
                  if (mounted) {
                    setState(() {
                      applyFriendsModel = applyFriendsModel;
                    });
                    if (!_enableControlFinish) {
                      _controller2._controller.finishLoad(
                          noMore: applyFriendsModel.listData.list.length >= applyFriendsModel.listData.total);
                    }
                  }
                });
              }
            : null,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var item = applyFriendsModel.listData.list[index];
                return _getItem(context, index, item);
              },
              childCount: applyFriendsModel.listData.list.length,
            ),
          ),
        ],
      ),
    );
  }

  // 顶部的布局
  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HomeAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(0, 2), blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            // 左箭头
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: const Material(color: Colors.transparent, child: Text("")),
            ),

            // 中间文字
            Expanded(flex: 2, child: getCenterText()),

            Spacer()
          ],
        ),
      ),
    );
  }

  Widget getCenterText() {
    return Center(
        child: SwitchAppBarButton.custom(
      (text) {
        setState(() {
          _currChose = text!;
          _currIndex = _switchList.indexOf(_currChose);
        });
        print("选中了 $text");
      },
      _switchList,
      value: _currChose,
    ));
  }
}
