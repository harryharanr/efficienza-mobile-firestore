import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditShiftMaster extends StatefulWidget {
  static const routeName = '/edit-shift-master';

  @override
  _EditShiftMasterState createState() => _EditShiftMasterState();
}

class _EditShiftMasterState extends State<EditShiftMaster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Shift Master'),
      ),
      body: Center(
        child: Text('Edit Shift Master'),
      ),
    );
  }
}
