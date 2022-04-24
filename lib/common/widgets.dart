import 'package:demo_app/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_image_compress/flutter_image_compress.dart';

typedef OnChanged = void Function(String? text);
typedef OnTap = void Function();

class SearchBar extends StatefulWidget {
  OnChanged onChanged;
  OnTap onTap;

  SearchBar.custom(this.onChanged, this.onTap, {Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  _SearchBarState();

  @override
  Widget build(BuildContext context) {
    return getSearchBarUI(super.widget.onChanged, super.widget.onTap);
  }
}

Widget getSearchBarUI(OnChanged onChanged, OnTap onTap) {
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
                  onChanged: onChanged,
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
            color: AppTheme.primaryColor,
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
              onTap: onTap,
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

class SwitchAppBarButton extends StatefulWidget {
  OnChanged onChanged;
  List<String> values;
  String? value;

  SwitchAppBarButton.custom(this.onChanged, this.values, {String? value, Key? key}) : super(key: key) {
    if (value != null) {
      this.value = value;
    } else {
      this.value = values[0];
    }
  }

  @override
  State<SwitchAppBarButton> createState() => _SwitchAppBarButtonState();
}

class _SwitchAppBarButtonState extends State<SwitchAppBarButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: super.widget.value,
        onChanged: super.widget.onChanged,
        items: super.widget.values.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          );
        }).toList(),
      ),
    ));
  }
}

class EasyRefreshUtil {

  static Container? empty(int count) {
    return count == 0
        ? Container(
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Expanded(
                  child: SizedBox(),
                  flex: 2,
                ),
                SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: Image.asset('assets/images/nodata.png'),
                ),
                Text(
                  "暂无数据",
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[400]),
                ),
                const Expanded(
                  child: SizedBox(),
                  flex: 3,
                ),
              ],
            ),
          )
        : null;
  }
}

//封装图片加载控件，增加图片加载失败时加载默认图片
class ImageWidget {

  static Widget getImage(String url) {
    return FadeInImage.assetNetwork(
      placeholder: "assets/images/nodata.png",
      image: url,
      fit: BoxFit.cover,
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset("assets/images/nodata.png");
      },
    );
  }
}

class ImageCompose {
  /// 图片压缩 File -> File
  static Future<File?> imageCompressAndGetFile(File file) async {
    if (file.lengthSync() < 200 * 1024) {
      return file;
    }
    var quality = 100;
    if (file.lengthSync() > 4 * 1024 * 1024) {
      quality = 50;
    } else if (file.lengthSync() > 2 * 1024 * 1024) {
      quality = 60;
    } else if (file.lengthSync() > 1 * 1024 * 1024) {
      quality = 70;
    } else if (file.lengthSync() > 0.5 * 1024 * 1024) {
      quality = 80;
    } else if (file.lengthSync() > 0.25 * 1024 * 1024) {
      quality = 90;
    }
    var dir = await path_provider.getTemporaryDirectory();
    var targetPath = dir.absolute.path +"/"+DateTime.now().millisecondsSinceEpoch.toString()+ ".jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: 300,
      quality: quality,
      rotate: 0,
    );

    print("压缩前：${file.lengthSync() / 1024}");
    if (result != null) {
      print("压缩后：${result.lengthSync() / 1024}");
    }

    return result;
  }

}