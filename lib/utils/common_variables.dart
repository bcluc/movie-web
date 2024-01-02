import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final vnDateFormat = DateFormat('dd/MM/yyyy');

get primaryColor => (BuildContext context) => Theme.of(context).colorScheme.primary;

TextStyle errorTextStyle(
  BuildContext context, {
  fontSize,
  fontWeight,
}) {
  return TextStyle(
    color: Theme.of(context).colorScheme.error,
    fontSize: fontSize,
    fontWeight: fontWeight,
  );
}
