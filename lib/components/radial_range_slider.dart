import 'package:flutter/cupertino.dart';
import 'package:show_time/core/constants/custom_variables.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


class RadialRangeSlider extends StatefulWidget{
  final Color textColor;
  final Color backgroundColor;
  final double radiusFactor;


  const RadialRangeSlider({Key? key,required this.textColor,required this.backgroundColor, this.radiusFactor = 0.8}) : super(key: key);

  @override
  _RadialRangeSliderState createState() => _RadialRangeSliderState();
}

class _RadialRangeSliderState  extends State<RadialRangeSlider> {
  _RadialRangeSliderState();

  final bool _enableDragging = true;
  double _secondMarkerValue = 30;
  double _firstMarkerValue = 0;
  final double _markerSize = 25;
  final double _annotationFontSize = 20;
  String _annotationValue1 = '0';
  String _annotationValue2 = '3.0';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 150,
        height: 150,
        child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(
                radiusFactor: widget.radiusFactor,
                axisLineStyle: AxisLineStyle(
                    color: widget.textColor,
                    thickness: 0.05,
                    thicknessUnit: GaugeSizeUnit.factor),
                showLabels: false,
                showTicks: false,
                startAngle: 90,
                endAngle: 90,
                ranges: <GaugeRange>[
                  GaugeRange(
                    endValue: _secondMarkerValue,
                    startValue: _firstMarkerValue,
                    sizeUnit: GaugeSizeUnit.factor,
                    color: widget.backgroundColor,
                    endWidth: 0.05,
                    startWidth: 0.05,
                  )
                ],
                pointers: <GaugePointer>[
                  MarkerPointer(
                    value: _firstMarkerValue,
                    elevation: 5,
                    onValueChanged: handleFirstPointerValueChanged,
                    onValueChanging: handleFirstPointerValueChanging,
                    enableDragging: _enableDragging,
                    color: _enableDragging
                        ? widget.backgroundColor
                        : GlobalColors.greyTextColor,
                    markerHeight: _markerSize,
                    markerWidth: _markerSize,
                    markerType: MarkerType.circle,
                  ),
                  MarkerPointer(
                    value: _secondMarkerValue,
                    elevation: 5,
                    onValueChanged: handleSecondPointerValueChanged,
                    onValueChanging: handleSecondPointerValueChanging,
                    enableDragging: _enableDragging,
                    color: _enableDragging
                        ? widget.backgroundColor
                        : GlobalColors.greyTextColor,
                    markerHeight: _markerSize,
                    markerWidth: _markerSize,
                    markerType: MarkerType.circle,
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: Text(
                      '$_annotationValue1 - $_annotationValue2',
                      style: TextStyle(
                        fontSize: _annotationFontSize,
                        fontFamily: 'Raleway',
                        color: GlobalColors.greyTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    positionFactor: 0.05,
                  )
                ])
          ],
        ),
      ),
    );
  }

  /// Dragged pointer new value is updated to pointer and
  /// annotation current value.
  void handleSecondPointerValueChanged(double value) {
    setState(() {
      _secondMarkerValue = value;
      final double _value = (_secondMarkerValue.abs().toInt()/10);
      _annotationValue2 = '$_value';
    });
  }

  /// Pointer dragging is canceled when dragging pointer value is less than 6.
  void handleSecondPointerValueChanging(ValueChangingArgs args) {
    if (args.value <= _firstMarkerValue ||
        (args.value - _secondMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  /// Value changed call back for first pointer
  void handleFirstPointerValueChanged(double value) {
    setState(() {
      _firstMarkerValue = value;
      final double _value = _firstMarkerValue.abs().toInt()/10;
      _annotationValue1 = '$_value';
    });
  }

  /// Value changeing call back for first pointer
  void handleFirstPointerValueChanging(ValueChangingArgs args) {
    if (args.value >= _secondMarkerValue ||
        (args.value - _firstMarkerValue).abs() > 10) {
      args.cancel = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

}