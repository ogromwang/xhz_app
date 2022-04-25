import 'dart:io';

import 'package:demo_app/common/number.dart';
import 'package:demo_app/model/record/record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../home/slider_view.dart';
import 'package:demo_app/common/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PushRecordScreen extends StatefulWidget {
  @override
  _PushRecordScreenState createState() => _PushRecordScreenState();
}

class _PushRecordScreenState extends State<PushRecordScreen> {
  RecordModel _recordModel = RecordModel();
  final imagePicker = ImagePicker();

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
                      _recordModel.push(context);
                    },
                    child: const Center(
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

  /// 内容
  Widget contentViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            '内容',
            textAlign: TextAlign.left,
            style:
                TextStyle(color: Colors.grey, fontSize: ScreenUtil.getInstance().setSp(40), fontWeight: FontWeight.normal),
          ),
        ),
        photoBox(),
        const SizedBox(
          height: 8,
        ),
        getTextField(
          hintText: "描述一下吧..",
        ),
        const SizedBox(
          height: 8,
        ),
        SliderView(
          distValue: _recordModel.money,
          onChangedistValue: (double value) {
            print(value);
            _recordModel.money = value;
          },
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget photoBox() {
    double? height = ScreenUtil.getInstance().setSp(300);
    double vertical = ScreenUtil.getInstance().setSp(12);
    double horizontal = ScreenUtil.getInstance().setSp(12);
    double width = ScreenUtil.getInstance().setSp(150);
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: InkWell(
            onTap: () {
              // 弹出底部选择
              openBottom();
            },
            child: Container(
              width: width,
              padding: EdgeInsets.symmetric(
                vertical: vertical,
                horizontal: horizontal,
              ),
              margin: EdgeInsets.fromLTRB(0, 0, 4, 0),
              height: height,
              alignment: Alignment.center,
              child: showPhoto(height),
            ),
          )
        ),
        // Spacer(flex: 3)
      ],
    );
  }

  Widget showPhoto(double? height) {
    if (_recordModel.photo.isNotEmpty) {
      return Expanded(
        child: Image.file(
          File(_recordModel.photo),
          height: height,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Icon(Icons.add, size: ScreenUtil.getInstance().setSp(110), color: Colors.grey);
    }
  }

  void openBottom() {
    //出现底部弹窗
    showModalBottomSheet(
      context: context,
      //自定义底部弹窗布局
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        //返回内部
        return SizedBox(
          height: ScreenUtil.getInstance().setHeight(300.0),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(width: 1.0, color: Colors.black12)),
                ),
                height: ScreenUtil.getInstance().setHeight(110.0),
                width: double.infinity,
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    final pickFile = await imagePicker.getImage(source: ImageSource.camera);

                    if (pickFile != null) {
                      setState(() {
                        _recordModel.photo = pickFile.path;
                      });
                    }

                  },
                  child: Center(
                    child: Text(
                      '拍照',
                      style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(45.0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(110.0),
                width: ScreenUtil.getInstance().setWidth(750.0),
                child: InkWell(
                  onTap: () async {
                    Navigator.pop(context);

                    final pickFile = await imagePicker.getImage(source: ImageSource.gallery);
                    if (pickFile != null) {
                      setState(() {
                        _recordModel.photo = pickFile.path;
                      });
                    }
                  },
                  child: Center(
                    child: Text(
                      '从相册选择',
                      style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(45.0),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getTextField({
    required String hintText,
    TextInputType keyboardType = TextInputType.multiline,
    TextInputAction textInputAction = TextInputAction.next,
    int length = 100,
  }) {
    double? fontSize = 15;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 3,
      ),
      margin: EdgeInsets.fromLTRB(4, 2, 4, 2),
      height: 100,
      alignment: Alignment.topCenter,
      child: TextField(
        maxLines: 4,
        minLines: 1,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: fontSize),
        inputFormatters: <TextInputFormatter>[
          LengthLimitingTextInputFormatter(length),
        ],
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: fontSize),
          isDense: true,
          contentPadding: EdgeInsets.all(4),
          border: InputBorder.none,
        ),
        onChanged: (val) {
          // 文本变化的回调
          setState(() {
            _recordModel.desc = val;
          });
        },
        onSubmitted: (_) {
          // 点击发送按钮的回调
        },
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  Widget allVisibility() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            '可见性',
            textAlign: TextAlign.left,
            style:
                TextStyle(color: Colors.grey, fontSize: ScreenUtil.getInstance().setSp(40), fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: visibility(),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  List<Widget> visibility() {
    final List<Widget> noList = <Widget>[];
    noList.add(
      Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          onTap: () {
            setState(() {
              checkbox();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "全部可见",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                CupertinoSwitch(
                  activeColor: _recordModel.isSelected ? HomeAppTheme.buildLightTheme().primaryColor : Colors.grey.withOpacity(0.6),
                  onChanged: (bool value) {
                    setState(() {
                      checkbox();
                    });
                  },
                  value: _recordModel.isSelected,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    return noList;
  }

  void checkbox() {
    if (_recordModel.isSelected) {
      _recordModel.isSelected = false;
    } else {
      _recordModel.isSelected = true;
    }
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
