import 'package:demo_app/common/number.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/common/app_theme.dart';
import 'package:flutter/services.dart';

class SliderView extends StatefulWidget {
  const SliderView({Key? key, this.onChangedistValue, this.distValue})
      : super(key: key);

  final Function(double)? onChangedistValue;
  final double? distValue;

  @override
  _SliderViewState createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  double distValue = 50.0;

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
                flex: 100 - distValue.round(),
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
                  distValue = value;
                });
                try {
                  widget.onChangedistValue!(distValue);
                } catch (_) {}
              },
              min: 0,
              max: 100,
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
      // controller: _money,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter(RegExp("[0-9.]"), allow: true),
        MyNumberTextInputFormatter(digit: 2),
      ],
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: '${(distValue).toStringAsFixed(2)}',
        hintStyle: TextStyle(color: Color.fromRGBO(119, 119, 119, 1), height: 1),
      ),
      autofocus: false,
      onChanged: (val) {
        setState(() {
          distValue = val as double;
        });
      },
    );

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 60),
          child: Text("本次花销: ", style: TextStyle(fontWeight: FontWeight.w200, fontSize: 10),),
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
