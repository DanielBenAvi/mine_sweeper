import 'package:flutter/material.dart';

class Block extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const Block({
    super.key,
    required this.width,
    required this.height,
    required this.text,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Center(
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: Center(
              child: textToWidget(text),
            ),
          ),
        ),
      ),
    );
  }

  Widget textToWidget(String text) {
    if (text == 'B') {
      return Image.asset('assets/images/bomb.png', width: 30, height: 30);
    }
    if (text == 'F') {
      return Image.asset('assets/images/flag.png', width: 30, height: 30);
    }
    return Text(text);
  }
}
