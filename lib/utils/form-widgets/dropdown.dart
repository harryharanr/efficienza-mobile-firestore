import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';

Widget buildDropdown(
    {String attribute,
    String labelText,
    String hintText,
    List<Map<String, String>> options}) {
  return FormBuilderDropdown(
    hint: Text(hintText),
    allowClear: true,
    attribute: attribute,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    items: options
        .map((item) => DropdownMenuItem(
              value: item['id'],
              child: Text(item['displayName']),
            ))
        .toList(),
  );
}
