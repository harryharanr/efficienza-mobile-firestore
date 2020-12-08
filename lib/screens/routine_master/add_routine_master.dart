import 'package:flutter/material.dart';

class AddRoutineMaster extends StatefulWidget {
  static const routeName = '/add-routine-master';
  @override
  _AddRoutineMasterState createState() => _AddRoutineMasterState();
}

class _AddRoutineMasterState extends State<AddRoutineMaster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Routine'),
      ),
      body: Center(
        child: Text('Add Routine'),
      ),
    );
  }
}
