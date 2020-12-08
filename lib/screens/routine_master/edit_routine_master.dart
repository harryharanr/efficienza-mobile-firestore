import 'package:flutter/material.dart';

class EditRoutineMaster extends StatefulWidget {
  static const routeName = '/edit-routine-master';

  @override
  _EditRoutineMasterState createState() => _EditRoutineMasterState();
}

class _EditRoutineMasterState extends State<EditRoutineMaster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Routine'),
      ),
      body: Center(
        child: Text('Edit Routine'),
      ),
    );
  }
}
