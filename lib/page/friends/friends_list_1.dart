import 'dart:async';

import 'package:demo_app/common/app_theme.dart';
import 'package:demo_app/model/account/friends_list_model.dart';
import 'package:demo_app/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class MyFriendsList extends StatefulWidget {

  const MyFriendsList({Key? key}) : super(key: key);

  @override
  _MyFriendsListState createState() => _MyFriendsListState();
}

class _MyFriendsListState extends State<MyFriendsList> {
  late EasyRefreshController _controller;
  late ScrollController _scrollController;

  var stateModel = FriendsListModel();

  // Header浮动
  bool _headerFloat = false;

  // 无限加载
  bool _enableInfiniteLoad = true;

  // 控制结束
  bool _enableControlFinish = false;

  // 震动
  bool _vibration = true;

  // 是否开启刷新
  bool _enableRefresh = true;

  // 是否开启加载
  bool _enableLoad = true;

  String get title => title;


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
              width: MediaQuery.of(context).size.width - 100,
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
        floatingActionButton: FloatingAddFriendButton(),
        body: Column(children: <Widget>[
          getAppBarUI(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: EasyRefresh.custom(
                firstRefresh: true,
                enableControlFinishRefresh: true,
                enableControlFinishLoad: true,
                taskIndependence: false,
                controller: _controller,
                scrollController: _scrollController,
                reverse: false,
                scrollDirection: Axis.vertical,
                topBouncing: true,
                bottomBouncing: true,
                header: _enableRefresh
                    ? ClassicalHeader(
                  enableInfiniteRefresh: false,
                  bgColor: _headerFloat ? Theme.of(context).primaryColor : Colors.transparent,
                  infoColor: _headerFloat ? Colors.black87 : Colors.teal,
                  float: _headerFloat,
                  enableHapticFeedback: _vibration,
                ) : null,
                footer: _enableLoad
                    ? ClassicalFooter(
                  enableInfiniteLoad: _enableInfiniteLoad,
                  enableHapticFeedback: _vibration,
                ) : null,
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
                      return _getItem(context, index);
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
             const Expanded(
               flex: 2,
               child: Center(
                 child: Text(
                   "我的好友",
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
