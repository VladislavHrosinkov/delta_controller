import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

enum TextState {
  blank,
  playing,
  complete
}

class CustomAnimatedText extends StatefulWidget {
  final String text;
  final double? fontSize;
  final int pause;

  const CustomAnimatedText({
    Key? key,
    required this.text,
    required this.pause,
    this.fontSize = 15.0,
  }) : super(key: key);

  @override
  _CustomAnimatedTextState createState() => _CustomAnimatedTextState();
}

class _CustomAnimatedTextState extends State<CustomAnimatedText> {
  
  TextState _animationStage = TextState.blank;

  @override
  void initState() {
    super.initState();
    // Add a delay of 2 seconds before starting the animation
    Future.delayed(Duration(milliseconds: widget.pause), () {
      setState(() {
        _animationStage = TextState.playing;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_animationStage == TextState.playing)
        ? AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              widget.text,
              textStyle: TextStyle(
                fontSize: widget.fontSize
              ),
              speed: Duration(milliseconds: 75),
            )
          ],
          isRepeatingAnimation: false,
          totalRepeatCount: 1,
          onFinished: () {
            setState(() {
              _animationStage = TextState.complete;
            });
          },
        )
        : (_animationStage == TextState.blank) ? 
        Container():
        Text(widget.text,
          style: TextStyle(
            fontSize: widget.fontSize
          ),
        ); 
  }
}
