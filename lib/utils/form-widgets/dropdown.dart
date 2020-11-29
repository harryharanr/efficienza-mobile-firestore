import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';

Widget buildDropdown(
    {String attribute, String labelText, List<String> options}) {
  return FormBuilderDropdown(
    attribute: attribute,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    items: options
        .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item),
            ))
        .toList(),
  );
}
