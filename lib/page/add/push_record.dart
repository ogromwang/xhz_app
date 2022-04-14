import 'package:demo_app/common/number.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home/slider_view.dart';
import 'package:demo_app/common/app_theme.dart';

class Data {

  String titleTxt;
  bool isSelected;

  Data(this.titleTxt, this.isSelected);
}

class PushRecordScreen extends StatefulWidget {
  @override
  _PushRecordScreenState createState() => _PushRecordScreenState();
}

class _PushRecordScreenState extends State<PushRecordScreen> {
  double money = 0;
  List<Data> checkBoxList = [];


  @override
  void initState() {
    checkBoxList.add(Data("拖拽输入", true));
    checkBoxList.add(Data("全部可见", true));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HomeAppTheme
          .buildLightTheme()
          .backgroundColor,
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
                    // 一个 input
                    distanceViewUI(),

                    const Divider(
                      height: 1,
                    ),
                    // 两个 input
                    allVisibility(),
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
                  color: HomeAppTheme
                      .buildLightTheme()
                      .primaryColor,
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
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        '发布',
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

  Widget distanceViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            '内容相关',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery
                    .of(context)
                    .size
                    .width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        SliderView(
          distValue: money,
          onChangedistValue: (double value) {
            money = value;
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget allVisibility() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            '可见性',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery
                    .of(context)
                    .size
                    .width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: visibility(1),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  List<Widget> visibility(int checkBoxIndex) {
    final List<Widget> noList = <Widget>[];
    var box = checkBoxList[checkBoxIndex];
    noList.add(
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          onTap: () {
            setState(() {
              checkbox(box);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    box.titleTxt,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                CupertinoSwitch(
                  activeColor: box.isSelected
                      ? HomeAppTheme
                      .buildLightTheme()
                      .primaryColor
                      : Colors.grey.withOpacity(0.6),
                  onChanged: (bool value) {
                    setState(() {
                      checkbox(checkBoxList[checkBoxIndex]);
                    });
                  },
                  value: box.isSelected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return noList;
  }

  void checkbox(Data data) {
    if (data.isSelected) {
      data.isSelected = false;
    } else {
      data.isSelected = true;
    }
  }

  /// 上方的 app bar
  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HomeAppTheme
            .buildLightTheme()
            .backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(color: Colors.grey.withOpacity(0.2), offset: const Offset(0, 2), blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery
            .of(context)
            .padding
            .top, left: 8, right: 8),
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
                  '发布记录',
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
