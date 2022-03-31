import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:ui';
import 'package:demo_app/model/result/account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/common/app_theme.dart';
import 'package:demo_app/routes/navigation.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> with TickerProviderStateMixin {
  // 动画
  AnimationController? animationController;

  double pageOffset = 0;
  late PageController pageController;

  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  AccountFriendResultData data = AccountFriendResultData([], 0);

  int page = 1;
  int pageSize = 30;

  var mock = """{
    "code": 200,
    "data": [{
        "id": 5,
        "username": "haohao",
        "password": "",
        "profile_picture": "172.16.68.10:9000/image/picture_f71c9e35-083c-4f71-931b-c1db98d99910.jpg",
        "createAt": "2022-03-28T16:23:13.912566Z"
    },{
        "id": 6,
        "username": "jiangjiang",
        "password": "",
        "profile_picture": "172.16.68.10:9000/image/picture_f71c9e35-083c-4f71-931b-c1db98d99910.jpg",
        "createAt": "2022-03-28T16:23:13.912566Z"
    }],
    "error": ""
}""";

  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    pageController = PageController(viewportFraction: 0.84);
    pageController.addListener(() {
      setState(() => pageOffset = pageController.page!);
    });

    requestData();

    super.initState();
  }

  Iterable<void> requestData() sync* {
    BaseOptions options = BaseOptions();
    ///请求header的配置
    options.headers["X-TOKEN"] = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJRCI6NiwiVXNlcm5hbWUiOiJqaWFuZ2ppYW5nIiwiSWNvbiI6ImltYWdlL3Rlc3QxLmpwZyIsImV4cCI6MTY0OTE0MjI1OCwiaXNzIjoiamlhbmdqaWFuZyJ9.Hf8HDHlU2mDBy8uaIzZCjHCShMSpcvRepnxaRT_PDNo';
    options.contentType="application/json";
    options.method="GET";
    options.connectTimeout=30000;
    ///创建 dio
    Dio dio = Dio(options);

    ///请求地址 获取用户列表
    String url = "http://172.16.68.10/v1/account/friends?page=$page&pageSize=$pageSize";

    ///发起get请求
    dio.request(url).then((value) {
      // 请求成功
      if (value.statusCode == 200) {
        var result = AccountFriendResult.fromJson(value.data);
        if (result.code == 200) {
          if (result.data != null) {
            data.list.addAll(result.data.list);
            data.total = result.data.total;
            page++;
          }
        } else {
          // 提示错误
        }
      } else {

      }

    }).onError((error, stackTrace) {
      print(error);
    });

  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HomeAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          floatingActionButton: FloatingAddFriendButton(),
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
                child: Column(children: <Widget>[
                  getAppBarUI(),
                  // Flexible组件可以使Row、Column、Flex等子组件在主轴方向有填充可用空间的能力，但是不强制子组件填充可用空间。
                  // Expanded组件可以使Row、Column、Flex等子组件在其主轴方向上展开并填充可用空间，是强制子组件填充可用空间。
                  Expanded(
                    // 可嵌套的滚动
                    child: NestedScrollView(
                        controller: _scrollController,
                        // 滑动可以隐藏
                        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                return Column(children: []);
                              }, childCount: 1),
                            ),
                          ];
                        },

                        // 这里是在渲染数据了
                        body: friendsWidget(context)),
                  )
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget friendsWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Container(
                child: CustomScrollView(
                  slivers: <Widget>[
                    //下拉刷新组件
                    CupertinoSliverRefreshControl(
                      //下拉刷新回调
                      onRefresh: () async {
                        print("下拉刷新");
                        //模拟网络请求
                        await Future.delayed(Duration(milliseconds: 1000));
                        //结束刷新
                        return Future.value(true);
                      },
                    ),
                    //列表
                    SliverList(
                      delegate: SliverChildBuilderDelegate((content, index)  {
                        print("当前index: $index");
                        return _getItem(context, index);
                      }, childCount: 100),
                    )
                  ],
                ),
              )),
          )
        ],
      ),
    );
  }

  Widget _getItem(BuildContext context, int index) {
    int num = data.list.length;
    if (index > num -1) {
      // 分页重新加载数据，追加数据
      requestData();
    }
    var item = data.list[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
        ]
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
            const Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  '好友',
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
