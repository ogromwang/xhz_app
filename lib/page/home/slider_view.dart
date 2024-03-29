import 'package:demo_app/common/number.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/common/app_theme.dart';
import 'package:flutter/services.dart';

class SliderView extends StatefulWidget {
  SliderView({
    Key? key,
    this.onChangedistValue,
    this.distValue,
    this.maxLen=100,
    this.hitText="本次花销"
  })
      : super(key: key);

  final Function(double)? onChangedistValue;
  final double? distValue;
  double maxLen;
  String hitText;

  @override
  _SliderViewState createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  double distValue = 0;
  bool numberPoint = false;
  var offset = 0;

  @override
  void initState() {
    distValue = widget.distValue!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: distValue.round(),
                child: const SizedBox(),
              ),
              Container(
                width: 170,
                child: testInput()
              ),
              Expanded(
                flex: widget.maxLen.toInt() - distValue.round(),
                child: const SizedBox(),
              ),
            ],
          ),
          SliderTheme(
            data: SliderThemeData(
              thumbShape: CustomThumbShape(),
            ),
            child: Slider(
              onChanged: (double value) {
                setState(() {
                  distValue = double.parse(value.toStringAsFixed(2));
                  if (value == 0) {
                    widget.maxLen = 100;
                  }
                });
                try {
                  widget.onChangedistValue!(distValue);
                } catch (_) {}
              },
              min: 0,
              max: widget.maxLen,
              activeColor: HomeAppTheme.buildLightTheme().primaryColor,
              inactiveColor: Colors.grey.withOpacity(0.4),
              // divisions: 100,
              value: distValue,
            ),
          ),
        ],
      ),
    );
  }

  Widget testInput() {
    var text = TextField(
      controller: TextEditingController
          .fromValue(
          TextEditingValue(
              text: distValue == 0 ? "" : "$distValue",
              selection:TextSelection.fromPosition(
                  TextPosition(
                    affinity:TextAffinity.downstream,
                    offset: offset
                  ))
          )
      ),
      // controller: _money,
      keyboardType: TextInputType.text,
      inputFormatters: [
        FilteringTextInputFormatter(RegExp("[0-9.]"), allow: true),
        MyNumberTextInputFormatter(digit: 2, numberPointFunc: () {
          print("让offset++");
          numberPoint = true;
        }),
      ],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '${(distValue).toStringAsFixed(2)}',
        hintStyle: TextStyle(color: Color.fromRGBO(119, 119, 119, 1), height: 1),
      ),
      autofocus: false,
      onChanged: (val) {
        var d = double.parse(val);
        setState(() {
          distValue = d;
          offset = MyNumberTextInputFormatter.getNumber(distValue.toStringAsFixed(2)).length;
          var dist = MyNumberTextInputFormatter.getDigit(distValue.toStringAsFixed(2));
          if (double.parse(dist) != 0) {
            var parse = int.parse(dist);
            if (parse % 10 == 0) {
              offset += 2;
            } else {
              offset += 3;
            }
          }
          if (numberPoint) {
            numberPoint = false;
            offset++;
          }

          if (d > 100) {
            widget.maxLen = distValue;
          }

          try {
            widget.onChangedistValue!(distValue);
          } catch (_) {}

        });
      },
    );

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 60),
          child: Text("${widget.hitText}: ", style: TextStyle(fontWeight: FontWeight.w200, fontSize: 10),),
        ),
        text,
      ],
    );
  }

}

class CustomThumbShape extends SliderComponentShape {
  static const double _thumbSize = 3.0;
  static const double _disabledThumbSize = 3.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return isEnabled
        ? const Size.fromRadius(_thumbSize)
        : const Size.fromRadius(_disabledThumbSize);
  }

  static final Animatable<double> sizeTween = Tween<double>(
    begin: _disabledThumbSize,
    end: _thumbSize,
  );

  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    Size? sizeWithOverflow,
    SliderThemeData? sliderTheme,
    TextDirection textDirection = TextDirection.ltr,
    double? textScaleFactor,
    double? value,
  }) {
    final Canvas canvas = context.canvas;
    final ColorTween colorTween = ColorTween(
      begin: sliderTheme?.disabledThumbColor,
      end: sliderTheme?.thumbColor,
    );
    canvas.drawPath(
        Path()
          ..addOval(Rect.fromPoints(
              Offset(thumbCenter.dx + 12, thumbCenter.dy + 12),
              Offset(thumbCenter.dx - 12, thumbCenter.dy - 12)))
          ..fillType = PathFillType.evenOdd,
        Paint()
          ..color = Colors.black.withOpacity(0.5)
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(8)));

    final Paint cPaint = Paint();
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.drawCircle(Offset(thumbCenter.dx, thumbCenter.dy), 12, cPaint);
    cPaint..color = colorTween.evaluate(enableAnimation!)!;
    canvas.drawCircle(Offset(thumbCenter.dx, thumbCenter.dy), 10, cPaint);
  }

  double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
