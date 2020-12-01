import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/form-widgets/text-field.dart';
import '../../utils/form-widgets/dropdown.dart';
import '../../utils/form-widgets/time-picker.dart';

class AddShiftMaster extends StatefulWidget {
  static const routeName = '/add-shift-master';
  @override
  _AddShiftMasterState createState() => _AddShiftMasterState();
}

class _AddShiftMasterState extends State<AddShiftMaster> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final User user = FirebaseAuth.instance.currentUser;

  var _initValues = {
    'plantName': '',
    'shiftName': '',
    'shiftStartTime': '',
    'shiftEndTime': '',
    'breakName': '',
    'breakStartTime': '',
    'breakEndTime': '',
    'description': '',
  };

  void _saveForm() async {
    final isValid = _fbKey.currentState.saveAndValidate();

    if (!isValid) {
      return;
    }

    await FirebaseFirestore.instance.collection('shift_master').add(
      {
        'plantName': _fbKey.currentState.value['plantName'],
        'shiftName': _fbKey.currentState.value['shiftName'],
        'shiftStartTime':
            _fbKey.currentState.value['shiftStartTime'].toString(),
        'shiftEndTime': _fbKey.currentState.value['shiftEndTime'].toString(),
        'breakName': _fbKey.currentState.value['breakName'],
        'breakStartTime':
            _fbKey.currentState.value['breakStartTime'].toString(),
        'breakEndTime': _fbKey.currentState.value['breakEndTime'].toString(),
        'description': _fbKey.currentState.value['description'],
        'createdAt': Timestamp.now(),
        'createdBy': user.uid,
      },
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Shift Master'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
            tooltip: 'Save',
          )
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('plant_master')
            .where('createdBy', isEqualTo: user.uid)
            .get(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final List<Map<String, String>> plantLists = [];
          final plantListsSnapshot = snapshot.data.docs;
          plantListsSnapshot.forEach((element) {
            plantLists
                .add({'id': element.id, 'displayName': element['plantName']});
          });
          _initValues = {
            'shiftName': '',
            'shiftStartTime': DateTime.now().toIso8601String(),
            'shiftEndTime': DateTime.now().toIso8601String(),
            'breakName': '',
            'breakStartTime': DateTime.now().toIso8601String(),
            'breakEndTime': DateTime.now().toIso8601String(),
            'description': ''
          };
          return FormBuilder(
              key: _fbKey,
              initialValue: _initValues,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                    child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    buildDropdown(
                      attribute: 'plantName',
                      labelText: 'Plant',
                      hintText: 'Select a plant',
                      options: plantLists,
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      attribute: 'shiftName',
                      labelText: 'Shift Name',
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: buildTimePicker(
                            initialValue: DateTime.now().toIso8601String(),
                            attribute: 'shiftStartTime',
                            labelText: 'Shift Start Time',
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: buildTimePicker(
                            initialValue: DateTime.now().toIso8601String(),
                            attribute: 'shiftEndTime',
                            labelText: 'Shift End Time',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      attribute: 'breakName',
                      labelText: 'Break Name',
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: buildTimePicker(
                            initialValue: DateTime.now().toIso8601String(),
                            attribute: 'breakStartTime',
                            labelText: 'Break Start Time',
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: buildTimePicker(
                            initialValue: DateTime.now().toIso8601String(),
                            attribute: 'breakEndTime',
                            labelText: 'Break End Time',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    buildTextField(
                      attribute: 'description',
                      labelText: 'Description',
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            child: Text('Submit'),
                            onPressed: _saveForm,
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            child: Text('Reset'),
                            onPressed: () {
                              _fbKey.currentState.reset();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ));
        },
      ),
    );
  }
}
