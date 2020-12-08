import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/form-widgets/text-field.dart';
import '../../utils/form-widgets/dropdown.dart';

class AddRoutineMaster extends StatefulWidget {
  static const routeName = '/add-routine-master';
  @override
  _AddRoutineMasterState createState() => _AddRoutineMasterState();
}

class _AddRoutineMasterState extends State<AddRoutineMaster> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  var _initValues = {
    'routineName': '',
    'equipmentName': '',
    'counterUnit': '',
    'counterType': '',
    'periodInMonths': '',
    'periodInYears': '',
    'remainderIndays': '',
    'routineDurationHrs': '',
    'routineDurationMins': '',
    'routineFrequency': '',
    'isConcurrentWith': '',
    'foregoRoutines': '',
  };

  void _saveForm() async {
    final User user = FirebaseAuth.instance.currentUser;
    final isValid = _fbKey.currentState.saveAndValidate();

    if (!isValid) {
      return;
    }

    await FirebaseFirestore.instance.collection('routine_master').add(
      {
        'routineName': _fbKey.currentState.value['routineName'],
        'equipmentName': _fbKey.currentState.value['equipmentName'],
        'counterUnit': _fbKey.currentState.value['counterUnit'],
        'counterType': _fbKey.currentState.value['counterType'],
        'periodInMonths': _fbKey.currentState.value['periodInMonths'],
        'periodInYears': _fbKey.currentState.value['periodInYears'],
        'remainderIndays': _fbKey.currentState.value['remainderIndays'],
        'routineDurationHrs': _fbKey.currentState.value['routineDurationHrs'],
        'routineDurationMins': _fbKey.currentState.value['routineDurationMins'],
        'routineFrequency': _fbKey.currentState.value['routineFrequency'],
        'isConcurrentWith': _fbKey.currentState.value['isConcurrentWith'],
        'foregoRoutines': _fbKey.currentState.value['foregoRoutines'],
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
        title: Text('Add Routine'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
            tooltip: 'Save',
          )
        ],
      ),
      body: FormBuilder(
          key: _fbKey,
          initialValue: _initValues,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  buildTextField(
                    attribute: 'routineName',
                    labelText: 'Routine Name',
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    attribute: 'equipmentName',
                    labelText: 'Equipment Name',
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    attribute: 'counterUnit',
                    labelText: 'Counter Unit',
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    attribute: 'counterType',
                    labelText: 'Counter Type',
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: buildTextField(
                          attribute: 'periodInMonths',
                          labelText: 'Periodicity (Months)',
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: buildTextField(
                          attribute: 'periodInYears',
                          labelText: 'Periodicity (Years)',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    attribute: 'remainderIndays',
                    labelText: 'Remainder (Days)',
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: buildTextField(
                          attribute: 'routineDurationHrs',
                          labelText: 'Routine (Hours)',
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: buildTextField(
                          attribute: 'routineDurationMins',
                          labelText: 'Routine (Minutes)',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    attribute: 'routineFrequency',
                    labelText: 'Routine Frequency',
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    attribute: 'isConcurrentWith',
                    labelText: 'Is Concurrent With',
                  ),
                  SizedBox(height: 20),
                  buildTextField(
                    attribute: 'foregoRoutines',
                    labelText: 'Forego Routines If Overlap',
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
              ),
            ),
          )),
    );
  }
}
