import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';

Widget buildTextField({String attribute, String labelText}) {
  return FormBuilderTextField(
    attribute: attribute,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}
