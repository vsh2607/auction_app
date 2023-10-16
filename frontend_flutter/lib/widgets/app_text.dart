import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  const AppText({
    super.key,
    required this.text,
    this.color = Colors.black,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.normal,
      ),
    );
    ;
  }
}
