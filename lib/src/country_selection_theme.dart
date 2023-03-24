import 'package:flutter/material.dart';

class CountryTheme {
  final String? searchHintText;
  final String? lastPickText;
  final Color? alphabetSelectedBackgroundColor;
  final Color? alphabetTextColor;
  final Color? alphabetSelectedTextColor;
  final bool? isShowTitle;
  final bool? isShowFlag;
  final bool? isShowCode;
  final bool? isDownIcon;
  final String? initialSelection;
  final Color? labelColor;

  CountryTheme({
    this.labelColor,
    this.searchHintText,
    this.lastPickText,
    this.alphabetSelectedBackgroundColor,
    this.alphabetTextColor,
    this.alphabetSelectedTextColor,
    this.isShowTitle,
    this.isShowFlag,
    this.isShowCode,
    this.isDownIcon,
    this.initialSelection,
  });
}
