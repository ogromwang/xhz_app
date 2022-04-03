import 'package:demo_app/common/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef OnChanged = void Function(String text);
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