import 'dart:async';

import 'package:demo_app/common/app_theme.dart';
import 'package:demo_app/common/widgets.dart';
import 'package:demo_app/model/account/find_friends_list_model.dart';
import 'package:demo_app/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FindFriends extends StatefulWidget {

  const FindFriends({Key? key}) : super(key: key);

  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {
  late EasyRefreshController _controller;
  late ScrollController _scrollController;

  var stateModel = SearchFriendsListModel();

  // 控制结束
  bool _enableControlFinish = false;

  // 是否开启刷新
  bool _enableRefresh = false;

  // 是否开启加载
  bool _enableLoad = false;


  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HomeAppTheme.buildLightTheme(),
      child: _scaffold(context),
    );
  }

  Widget _getSliceItem(BuildContext context, int index) {
    var item = stateModel.listData.list[index];
    return Slidable(
      key: ValueKey("$index"),
      // 同一组
      groupTag: "ccc",
      child: _getItem(context, index),
      // 左侧按钮列表
      startActionPane: ActionPane(
        extentRatio: 0.3,
        // 滑出选项的面板 动画
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              stateModel.applyAddFriend(context, item.id);
            },
            backgroundColor: Colors.teal,
            icon: Icons.account_circle_sharp,
            label: '申请好友',
          )
        ],

      )
    );
  }

  Widget _getItem(BuildContext context, int index) {
    var item = stateModel.listData.list[index];
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 100,
              child: Text(item.username, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        Divider()
      ]),
    );
  }


  Widget _scaffold(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
          getAppBarUI(),
          SearchBar.custom(
                  (text) {
                stateModel.username = text;
              },
                  () {
                // 每次点击搜索都是从第一页开始, 相当于刷新
                stateModel.refreshData(context).then((value) {
                  if (mounted) {
                    setState(() {
                      stateModel = stateModel;
                      var noMore = stateModel.listData.list.length >= stateModel.listData.total;
                      if (!noMore) {
                        _enableLoad = true;
                      }
                      if (!_enableControlFinish) {
                        _controller.finishLoad(noMore: noMore);
                      }
                    });
                  }
                });
              }
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: EasyRefresh.custom(
                firstRefresh: false,
                enableControlFinishRefresh: true,
                enableControlFinishLoad: true,
                taskIndependence: false,
                controller: _controller,
                scrollController: _scrollController,
                reverse: false,
                scrollDirection: Axis.vertical,
                topBouncing: false,
                bottomBouncing: true,
                // header: BallPulseHeader(),
                footer: BallPulseFooter(),
                onRefresh: _enableRefresh ? () async {
                  stateModel.refreshData(context).then((value) {
                    if (mounted) {
                      setState(() {
                        stateModel = stateModel;
                      });
                      if (!_enableControlFinish) {
                        _controller.resetLoadState();
                        _controller.finishRefresh();
                      }
                    }
                  });
                } : null,
                onLoad: _enableLoad ? () async {
                  stateModel.loadMoreData(context).then((value) {
                    if (mounted) {
                      setState(() {
                        stateModel = stateModel;
                      });
                      if (!_enableControlFinish) {
                        _controller.finishLoad(noMore: stateModel.listData.list.length >= stateModel.listData.total);
                      }
                    }
                  });
                } : null,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return _getSliceItem(context, index);
                    },
                      childCount: stateModel.listData.list.length,
                    ),
                  ),
                ],
              ),
            ),
          )
        ]));
  }

  // 顶部的布局
  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HomeAppTheme
            .buildLightTheme()
            .backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(0, 2), blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery
            .of(context)
            .padding
            .top, left: 8, right: 8),
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
            const Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  "搜寻用户",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),

            Spacer()
          ],
        ),
      ),
    );
  }
}
