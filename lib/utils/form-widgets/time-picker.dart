import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';

import '../date_converter.dart';

Widget buildTimePicker(
    {String initialValue, String attribute, String labelText}) {
  return FormBuilderDateTimePicker(
    initialValue: dateConverter(initialValue),
    attribute: attribute,
    inputType: InputType.time,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}
