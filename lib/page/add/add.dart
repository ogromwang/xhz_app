import 'package:demo_app/common/app_theme.dart';
import 'package:demo_app/page/home/app_theme.dart';
import 'package:flutter/material.dart';

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
          title: const Text(
            "添加",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          backgroundColor: Color(0xFF48CBB5),
          foregroundColor: Colors.white,
        ),
        body: Container(
          child: Center(
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                    child: TextField(
                        decoration: InputDecoration(
                            hintText: "请输入花销",
                            icon: Icon(Icons.attach_money_outlined),
                            alignLabelWithHint: true,
                            floatingLabelAlignment: FloatingLabelAlignment.center)
                    )
                ),

                // 横线
                Divider(),

                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: TextField(
                    decoration: InputDecoration(hintText: "请输入描述", icon: Icon(Icons.message_rounded)),
                  ),
                ),

                SizedBox(height: 40),
                ElevatedButton(
                  style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size.fromWidth(size.width*0.6)),
                      backgroundColor: MaterialStateProperty.all(const Color(0xFF162A49)),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        color: Colors.white,
                      )),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ))

                  ),
                  child: Text('确定'),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ));
  }
}
