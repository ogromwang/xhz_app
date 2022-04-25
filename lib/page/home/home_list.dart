import 'dart:ui';
import 'package:demo_app/common/widgets.dart';
import 'package:demo_app/model/goal/goal_model.dart';
import 'package:demo_app/model/record/record_all_model.dart';
import 'package:demo_app/model/record/result/record_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'filters_screen.dart';
import 'package:demo_app/common/app_theme.dart';
import 'package:demo_app/routes/navigation.dart';
import 'dart:math' as math;

class HotelHomeScreen extends StatefulWidget {
  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen> with TickerProviderStateMixin {
  // 动画
  AnimationController? animationController;
  final EasyRefreshController _controller = EasyRefreshController();
  final ScrollController _scrollController = ScrollController();

  double pageOffset = 0;
  late PageController pageController;
  var cir = Radius.circular(ScreenUtil.getInstance().setSp(25));

  // 控制结束
  bool _enableControlFinish = false;

  // 是否开启刷新
  bool _enableRefresh = true;

  // 是否开启加载
  bool _enableLoad = true;

  // 数据list
  RecordAllModel _recordAllModel = RecordAllModel();
  // 目标
  GoalModel _goalModel = GoalModel();

  final ScrollController _scrollController2 = ScrollController();

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    pageController = PageController(viewportFraction: 0.84);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page!);
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.getInstance().init(context);
    return Theme(
      data: HomeAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          floatingActionButton: FloatingAddButton(() {
            searchList();
          }),
          // stack 堆叠
          body: Stack(
            children: <Widget>[
              // 点击的时候会出现水波纹
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                // 列
                child: Column(
                  children: <Widget>[
                    getAppBarUI(),
                    // Flexible组件可以使Row、Column、Flex等子组件在主轴方向有填充可用空间的能力，但是不强制子组件填充可用空间。
                    // Expanded组件可以使Row、Column、Flex等子组件在其主轴方向上展开并填充可用空间，是强制子组件填充可用空间。
                    Expanded(
                      // 可嵌套的滚动
                      child: NestedScrollView(
                          controller: _scrollController2,
                          // 滑动可以隐藏
                          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              SliverList(
                                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                  return Column(
                                    children: <Widget>[
                                      getUserPlan(),
                                      // getSearchBarUI(),
                                    ],
                                  );
                                }, childCount: 1),
                              ),
                            ];
                          },

                          // 这里是在渲染数据了
                          body: _list(context)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取 list
  void searchList() {
    _recordAllModel.refreshData(context).then((value) {
      if (mounted) {
        setState(() {
          _recordAllModel = _recordAllModel;
        });
        if (!_enableControlFinish) {
          _controller.resetLoadState();
          _controller.finishRefresh();
        }
      }
    });
    _goalModel.getGoal(context).then((value) {
      _goalModel = _goalModel;
    });
  }

  /// 首页瀑布流
  Widget _list(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 1),
      child: EasyRefresh(
        firstRefresh: true,
        // firstRefreshWidget: Loading(),
        emptyWidget: EasyRefreshUtil.empty(_recordAllModel.data.list.length),
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        taskIndependence: false,
        controller: _controller,
        scrollController: _scrollController,
        topBouncing: false,
        bottomBouncing: false,
        header: BallPulseHeader(),
        footer: BallPulseFooter(),
        onRefresh: _enableRefresh
            ? () async {
                searchList();
              }
            : null,
        onLoad: _enableLoad
            ? () async {
                _recordAllModel.loadMoreData(context).then((value) {
                  if (mounted) {
                    setState(() {
                      _recordAllModel = _recordAllModel;
                    });
                    if (!_enableControlFinish) {
                      _controller.finishLoad(noMore: !_recordAllModel.data.more);
                    }
                  }
                });
              }
            : null,
        child: MasonryGridView.count(
          itemCount: _recordAllModel.data.list.length,
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          crossAxisCount: 2,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          itemBuilder: (context, index) {
            var item = _recordAllModel.data.list[index];
            return _getItem(context, index, item);
          },
        ),
      ),
    );
  }

  Widget _getItem(BuildContext context, int index, Item item) {
    double height = ScreenUtil.getInstance().setSp(800); // HotelListData.heightRandom[index % 7];
    // double height = HotelListData.heightRandom[index % 7];
    if (index == 0 || (index == _recordAllModel.data.list.length - 1 && index % 2 != 0)) {
      height = ScreenUtil.getInstance().setSp(660);
    }

    // var image = ImageWidget(url: item.image);
    var image = ImageWidget.getImage(item.image);

    var profile =  ImageWidget.getImage(item.profilePicture);

    // Color.fromARGB(math.Random().nextInt(256), math.Random().nextInt(256), math.Random().nextInt(256),

    var formatter = DateFormat('yy-MM-dd hh:mm:ss');
    var time = formatter.format(item.createdAt);

    return Card(
      elevation: 0.2,
      // Give each item a random background color
      color: Colors.white,
      child: Container(
        height: height,
        child: Column(
          children: [
            // 图片
            Expanded(
              flex: 8,
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Color(0xFFFF0000), width: 0.5),
                  borderRadius: BorderRadius.only(topLeft: cir, topRight: cir),
                ),
                width: double.infinity,
                child: ClipRRect(borderRadius: BorderRadius.only(topLeft: cir, topRight: cir),child: image),
              ),
            ),

            SizedBox(
              height: ScreenUtil.getInstance().setHeight(4)
            ),
            // 头像 - 名字
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  // 头像
                  Padding(
                    padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(10)),
                    child: Container(
                      height: ScreenUtil.getInstance().setSp(70),
                      width: ScreenUtil.getInstance().setSp(70),
                      child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(70.0)), child: profile),
                    ),
                  ),
                  // 名字
                  Padding(
                    padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(20), top: ScreenUtil.getInstance().setSp(5)),
                    child: Container(
                      width: ScreenUtil.getInstance().setWidth(200),
                      child: Text(
                          item.username,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppTheme.fontColor ,fontSize: ScreenUtil.getInstance().setSp(35), fontWeight: FontWeight.w400)
                      ),
                    )
                  )
                ],
              ),
            ),

            // 钱
            Container(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: ScreenUtil.getInstance().setSp(10), top: ScreenUtil.getInstance().setSp(5)),
                  child: Text(
                      "-￥"+item.money.toStringAsFixed(2),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppTheme.redColor ,fontSize: ScreenUtil.getInstance().setSp(40), fontWeight: FontWeight.w400)),
                )
            ),

            Expanded(
              flex: 2,
              child: Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Color(0xFFFF0000), width: 0.5),
                  ),
                  // height: height * 0.15,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil.getInstance().setSp(12)),
                    child: Text(
                        "\t\t" + item.describe,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey,fontSize: ScreenUtil.getInstance().setSp(30), fontWeight: FontWeight.normal)
                    ),
                  )
              ),
            ),
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
      ),
    );
  }

  Widget box(Color boxColor, Widget child) {
    return Container(
        height: ScreenUtil.getInstance().setHeight(60),
        //width: ScreenUtil.getInstance().setWidth(80),
        decoration: BoxDecoration(
          border: Border.all(color: boxColor, width: 1),
          // color: boxColor,
          borderRadius: BorderRadius.all(
            Radius.circular(ScreenUtil.getInstance().setSp(15))
          )
        ),
        child: child
    );
  }

  Widget getUserPlan() {
    double leftRight = ScreenUtil.getInstance().setSp(16);
    double bottom = ScreenUtil.getInstance().setSp(16);

    return Padding(
      padding: EdgeInsets.only(left: leftRight, right: leftRight, top: bottom, bottom: bottom),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              height: ScreenUtil.getInstance().setHeight(140),
              decoration: BoxDecoration(
                color: HomeAppTheme.buildLightTheme().backgroundColor,
                borderRadius: BorderRadius.all(
                    cir
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(0, 2), blurRadius: 8.0),
                ],
              ),
              child: moneyIcon(),
            ),
          ),

        ],
      ),
    );
  }

  Widget moneyIcon() {
    var name = "个人目标";
    var curr = 0.00;
    var goal = 0.00;
    var color = AppTheme.secondaryColor;

    for (var element in _goalModel.data) {
      if (element.type == 1) {
        name = element.name;
        curr = element.currMoney;
        goal = element.goal;

        if (goal > 0 && curr / goal > 0.7) {
          color = AppTheme.redColor;
        }
      }
    }

    return Padding(
      padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(28)),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              print("你点击了");
              openBottom();
            },
            child: box(color, Padding(
                padding: EdgeInsets.all(ScreenUtil.getInstance().setSp(3)),
                child: Text(name, style: TextStyle(fontSize: 12, color: color))
            ))
          ),
          Spacer(
            flex: 2,
          ),
          Expanded(
            flex: 2,
            child: Text("$curr / $goal", style: TextStyle(color: color),)
          )
        ],
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HomeAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(0, 2), blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {},
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    cursorColor: HomeAppTheme.buildLightTheme().primaryColor,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: HomeAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.grey.withOpacity(0.4), offset: const Offset(0, 2), blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.search, size: 20, color: HomeAppTheme.buildLightTheme().backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// filter 首页
  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: HomeAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(0, -2), blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: HomeAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '',
                      style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => FiltersScreen(), fullscreenDialog: true),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          const Text(
                            'Filter',
                            style: TextStyle(
                              fontWeight: FontWeight.w100,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.sort, color: HomeAppTheme.buildLightTheme().primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
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
            const Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  '首页',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),

            // 站位的作用
            const Spacer()
          ],
        ),
      ),
    );
  }


  void openBottom() {
    //出现底部弹窗

  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );

  final Widget searchUI;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
