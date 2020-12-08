import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/form-widgets/text-field.dart';

class AddPlantMaster extends StatefulWidget {
  static const routeName = '/add-plant-master';

  @override
  _AddPlantMasterState createState() => _AddPlantMasterState();
}

class _AddPlantMasterState extends State<AddPlantMaster> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  var _initValues = {
    'plantName': '',
    'address': '',
    'primaryContact': '',
  };

  void _saveForm() async {
    final User user = FirebaseAuth.instance.currentUser;
    final isValid = _fbKey.currentState.saveAndValidate();

    if (!isValid) {
      return;
    }

    await FirebaseFirestore.instance.collection('plant_master').add(
      {
        'plantName': _fbKey.currentState.value['plantName'],
        'address': _fbKey.currentState.value['address'],
        'primaryContact': _fbKey.currentState.value['primaryContact'],
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
        title: Text('Add Plant Master'),
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
                  attribute: 'plantName',
                  labelText: 'Plant Name',
                ),
                SizedBox(height: 20),
                buildTextField(
                  attribute: 'primaryContact',
                  labelText: 'Primary Contact',
                ),
                SizedBox(height: 20),
                buildTextField(
                  attribute: 'address',
                  labelText: 'Address',
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
        ),
      ),
    );
  }
}
