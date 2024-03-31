import 'package:admin/constants.dart';
import 'package:admin/controllers/SerialController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhaseControl extends StatefulWidget {
  @override
  State<PhaseControl> createState() => _PhaseControlState();
}

class _PhaseControlState extends State<PhaseControl> {
  SerialController? serialController = null;

  void updatePhase(String coordinate, double value) {
    switch (coordinate) {
      case "Motor 1":
        serialController!.sendPhase(value.toInt(), null, null);
        break;
      case "Motor 2":
        serialController!.sendPhase(null, value.toInt(), null);
        break;
      case "Motor 3":
        serialController!.sendPhase(null, null, value.toInt());
        break;
      default:
        print("Invalid phase: $coordinate");
    }
  }

  @override
  Widget build(BuildContext context) {
    serialController = context.watch<SerialController>();

    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CoordinateSlider("Motor 1", 0, -20, 90, updatePhase),
          CoordinateSlider("Motor 2", 0, -20, 90, updatePhase),
          CoordinateSlider("Motor 3", 0, -20, 90, updatePhase)
        ]
      )
    );
  }
}

class CoordinateSlider extends StatefulWidget {
  final String coordinate;
  final double min;
  final double max;
  final double initialVal;
  final updateCartesian;

  CoordinateSlider(this.coordinate, this.initialVal, this.min, this.max, this.updateCartesian, {Key? key}) : super(key: key);

  @override
  _CoordinateSliderState createState() => _CoordinateSliderState();
}

class _CoordinateSliderState extends State<CoordinateSlider> {
  late TextEditingController textController;
  late double value;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    value = widget.initialVal;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void updateSliderValue(double enteredValue) {
    setState(() {
      value = enteredValue;
      widget.updateCartesian(widget.coordinate, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    textController.text = value.toStringAsFixed(1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(widget.coordinate, style: TextStyle(fontSize: 30)),
        SizedBox(width: 20.0),
        SizedBox(
          width: 100,
          child: TextField(
            controller: textController,
            keyboardType: TextInputType.numberWithOptions(decimal: false),
            onSubmitted: (val) {
              if (val.isEmpty) return;
              double enteredValue = double.tryParse(val) ?? value;
              if (val.isEmpty) return; // Prevent empty input
              if (enteredValue < widget.min) {
                enteredValue = widget.min;
              } else if (enteredValue > widget.max) {
                enteredValue = widget.max;
              }
              updateSliderValue(enteredValue);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        SizedBox(width: 20),
        Slider(
          min: widget.min,
          max: widget.max,
          activeColor: secondaryColor,
          value: value,
          divisions: (widget.max - widget.min).toInt(), // Optional: adds divisions on the slider track
          label: value.toStringAsFixed(1), // Optional: displays a label while dragging the slider
          onChanged: (value) => {},
          onChangeEnd: (double val) {
            textController.text = val.toStringAsFixed(1);
            updateSliderValue(val);
          },
        )
      ],
    );
  }
}