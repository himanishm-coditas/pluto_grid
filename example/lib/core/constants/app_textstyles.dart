import 'package:example/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle columnTitleTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.2,
    letterSpacing: 0,
    color: AppColors.columnTitleTextColor,
  );
  static const TextStyle cellTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.2,
    letterSpacing: 0,
    color: AppColors.cellTextColor
  ,);
  static const TextStyle netChangeTextStyle = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 1.2,
    letterSpacing: 0,
  );

}
