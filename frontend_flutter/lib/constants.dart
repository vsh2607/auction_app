import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppColors {
  static const mainColor = Color.fromRGBO(208, 107, 55, 1);
  static const backGreyColor = Color.fromRGBO(247, 242, 242, 1);
}

class AppConstants {
  static double quarterScreenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height * 0.30;

  static double customScreenHeight(BuildContext context, double size) =>
      MediaQuery.of(context).size.height * size;
  static double customScreenWidth(BuildContext context, double size) =>
      MediaQuery.of(context).size.width * size;
}

class AppFunctions {
  static NumberFormat get rupiahFormat => NumberFormat.currency(
        locale: 'id_ID',
        symbol: 'Rp',
      );
}

class AppTimer {
  static String dateDeadlineFormat(String initialFormat) =>
      (DateFormat('d MMMM y, HH:mm')).format(DateTime.parse(initialFormat));
}
