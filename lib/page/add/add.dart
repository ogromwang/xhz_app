import 'package:demo_app/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddWidget extends StatefulWidget {
  const AddWidget({Key? key}) : super(key: key);

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          elevation: 0.8,
          title: const Text(
            "记录",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Container(
          decoration: BoxDecoration(
            color: HomeAppTheme.buildLightTheme().dialogBackgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(color: Colors.grey.withOpacity(0.8), offset: const Offset(0, 2), blurRadius: 8.0),
            ],
          ),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                  child: TextField(
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'/(^[1-9]\d*(\.\d{1,2})?$)|(^0(\.\d{1,2})?$)/'))
                    ], //限定数字输入
                    // 设置字体
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    // 设置输入框样式
                    decoration: const InputDecoration(
                      hintText: '本次花销',
                      // 边框
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          // 里面的数值尽可能大才是左右半圆形，否则就是普通的圆角形
                          Radius.circular(50),
                        ),
                      ),

                      // 设置内容内边距
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                      ),
                      // 前缀图标
                      prefixIcon: Icon(Icons.card_travel),
                    ),
                  ),
                ),

                // 横线
                const Divider(),

                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 6, 20, 0),
                  child: TextField(
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    // 设置字体
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    // 设置输入框样式
                    decoration: InputDecoration(
                      hintMaxLines: 2,
                      hintText: '简单描述',
                      // 边框
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          // 里面的数值尽可能大才是左右半圆形，否则就是普通的圆角形
                          Radius.circular(50),
                        ),
                      ),
                      // 设置内容内边距
                      contentPadding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                      ),
                      // 前缀图标
                      prefixIcon: Icon(Icons.messenger_outlined),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        fixedSize: MaterialStateProperty.all(Size.fromWidth(size.width * 0.4)),
                        backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                          color: Colors.white,
                        )),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ))),
                    child: const Text('发表'),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
