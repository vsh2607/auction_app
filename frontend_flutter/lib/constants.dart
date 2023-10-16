import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static const mainColor = Color.fromRGBO(208, 107, 55, 1);
}

class AppConstants {
  static double quarterScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.30;
}
