import 'dart:async';

import 'package:demo_app/common/app_theme.dart';
import 'package:demo_app/common/popup.dart';
import 'package:demo_app/common/widgets.dart';
import 'package:demo_app/model/account/my_apply_friends_list_model.dart';
import 'package:demo_app/model/account/my_friends_list_model.dart';
import 'package:demo_app/model/record/record_me_model.dart';
import 'package:demo_app/model/record/result/record_result.dart';
import 'package:demo_app/routes/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class MeList extends StatefulWidget {
  const MeList({Key? key}) : super(key: key);

  @override
  _MeListState createState() => _MeListState();
}

class _MeListState extends State<MeList> {

  var _recordMeModel = RecordMeModel();

  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();

  // 控制结束
  bool _enableControlFinish = false;

  // 是否开启刷新
  bool _enableRefresh = true;

  // 是否开启加载
  bool _enableLoad = true;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.getInstance().init(context);

    return Theme(
      data: HomeAppTheme.buildLightTheme(),
      child: _scaffold(context),
    );
  }

  Widget _getItem(BuildContext context, int index, Item item) {
    double height = ScreenUtil.getInstance().setSp(260);

    var cir = Radius.circular(ScreenUtil.getInstance().setSp(20));
    var image = ImageWidget(url: item.image);

    var profile = ImageWidget(url: item.profilePicture);

    // Color.fromARGB(math.Random().nextInt(256), math.Random().nextInt(256), math.Random().nextInt(256),

    var formatter = DateFormat('yy-MM-dd hh:mm:ss');
    var time = formatter.format(item.createdAt);

    return Card(
      // Give each item a random background color
      color: Colors.white,
      child: Container(
          height: height,
          child: Row(
            children: [
              // 图片
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Color(0xFFFF0000), width: 0.5),
                    borderRadius: BorderRadius.only(topLeft: cir, bottomLeft: cir),
                  ),
                  height: double.infinity,
                  child: ClipRRect(borderRadius: BorderRadius.only(topLeft: cir, bottomLeft: cir),child: image),
                ),
              ),

              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // 描述
                    Expanded(
                      flex: 2,
                      child: Container(
                          decoration: BoxDecoration(
                            // border: Border.all(color: Color(0xFFFF0000), width: 0.5),
                          ),
                          // height: height * 0.15,
                          width: double.infinity,
                          height: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.only(left: ScreenUtil.getInstance().setSp(12)),
                            child: Text(
                                "\t\t" + item.describe,
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey,fontSize: ScreenUtil.getInstance().setSp(30), fontWeight: FontWeight.normal)
                            ),
                          )
                      ),
                    ),

                    // 金钱
                    Expanded(
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: ScreenUtil.getInstance().setSp(10), top: ScreenUtil.getInstance().setSp(5)),
                              child: Text(
                                  "-￥"+item.money.toStringAsFixed(2),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: AppTheme.redColor ,fontSize: ScreenUtil.getInstance().setSp(40), fontWeight: FontWeight.w400)),
                            )
                        )
                    ),

                    // 时间
                    Container(
                      alignment: Alignment.bottomRight,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(2)),
                        child: Text(
                            time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey,fontSize: ScreenUtil.getInstance().setSp(25), fontWeight: FontWeight.normal)
                        ),
                      ),
                    )
                  ],
                )
              )
            ],
          )
      ),
    );
  }

  /// 内容
  Widget _scaffold(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
          getAppBarUI(),
          Expanded(
              child: _myRecord(context)
          )
        ]));
  }

  /// 我的花销记录
  Widget _myRecord(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: EasyRefresh.custom(
        firstRefresh: true,
        firstRefreshWidget: Loading(),
        emptyWidget: EasyRefreshUtil.empty(_recordMeModel.data.list.length),
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        taskIndependence: false,
        controller: _controller,
        scrollController: _scrollController,
        reverse: false,
        scrollDirection: Axis.vertical,
        topBouncing: true,
        bottomBouncing: true,
        header: BallPulseHeader(),
        footer: BallPulseFooter(),
        onRefresh: _enableRefresh
            ? () async {
          _recordMeModel.refreshData(context).then((value) {
            if (mounted) {
              setState(() {
                _recordMeModel = _recordMeModel;
              });
              if (!_enableControlFinish) {
                _controller.resetLoadState();
                _controller.finishRefresh();
              }
            }
          });
        }
            : null,
        onLoad: _enableLoad
            ? () async {
          _recordMeModel.loadMoreData(context).then((value) {
            if (mounted) {
              setState(() {
                _recordMeModel = _recordMeModel;
              });
              if (!_enableControlFinish) {
                _controller
                    .finishLoad(noMore: !_recordMeModel.data.more);
              }
            }
          });
        }
            : null,
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
                var item = _recordMeModel.data.list[index];
                return _getItem(context, index, item);
              },
              childCount: _recordMeModel.data.list.length,
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
            Expanded(flex: 2, child: getCenterText()),

            Spacer()
          ],
        ),
      ),
    );
  }

  Widget getCenterText() {
    return Center(
        child: Text(
          "我的",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
    );
  }

}
