import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const mainColor = Color.fromRGBO(208, 107, 55, 1);
}

class AppConstants {
  static double quarterScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.30;
}

class AppFunctions {
  static NumberFormat get rupiahFormat => NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
      );
}
