import 'package:flutter/material.dart';

class AppLargeText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;

  AppLargeText({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.size = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
