import 'dart:convert';

import 'package:demo_app/model/goal/goal_model.dart';
import 'package:demo_app/model/goal/result/goal_result_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../home/slider_view.dart';
import 'package:demo_app/common/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpdateGoalScreen extends StatefulWidget {

  OneGoal _goal;
  double goal = 0.0;

  UpdateGoalScreen(this._goal, {Key? key}) : super(key: key) {
    goal = _goal.goal;
  }

  @override
  _UpdateGoalScreenState createState() => _UpdateGoalScreenState();
}

class _UpdateGoalScreenState extends State<UpdateGoalScreen> {

  GoalModel _goalModel = GoalModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.getInstance().init(context);
    return Container(
      color: HomeAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const Divider(
                      height: 1,
                    ),
                    // 内容
                    contentViewUI(),

                    const Divider(
                      height: 1,
                    ),
                    // 两个 input
                    const Divider(
                      height: 1,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: HomeAppTheme.buildLightTheme().primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      var update = OneGoal(
                          id: widget._goal.id,
                          name: widget._goal.name,
                          goal: widget.goal,
                          currMoney: widget._goal.currMoney,
                          type: widget._goal.type,
                          accountIds: widget._goal.accountIds
                      );
                      _goalModel.setGoal(context, update);
                      print("提交当前值: ${json.encode(update)}");
                    },
                    child: const Center(
                      child: Text(
                        '修改',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 内容
  Widget contentViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        const SizedBox(
          height: 8,
        ),
        SliderView(
          hitText: "目标值",
          maxLen: widget.goal * 2,
          distValue: widget.goal,
          onChangedistValue: (double value) {
            widget.goal = value;
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  /// 上方的 app bar
  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HomeAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(0, 2), blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  '当前目标',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}
