import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/form-widgets/text-field.dart';

class EditPlantMaster extends StatefulWidget {
  static const routeName = '/edit-plant-master';

  @override
  _EditPlantMasterState createState() => _EditPlantMasterState();
}

class _EditPlantMasterState extends State<EditPlantMaster> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  var _initValues = {
    'plantName': '',
    'address': '',
    'primaryContact': '',
  };

  var itemId;

  @override
  void didChangeDependencies() async {
    itemId = ModalRoute.of(context).settings.arguments as String;
    super.didChangeDependencies();
  }

  void _updateForm() async {
    final User user = FirebaseAuth.instance.currentUser;
    final isValid = _fbKey.currentState.saveAndValidate();

    if (!isValid) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('plant_master')
        .doc(itemId)
        .update(
      {
        'plantName': _fbKey.currentState.value['plantName'],
        'address': _fbKey.currentState.value['address'],
        'primaryContact': _fbKey.currentState.value['primaryContact'],
        'createdBy': user.uid,
      },
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Plant Master'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('plant_master')
            .doc(itemId)
            .get(),
        builder: (ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData == false) {
            return Center(
              child: Text('No data!'),
            );
          }
          final fetchedItem = snapshot.data.data();
          _initValues = {
            'plantName': fetchedItem['plantName'],
            'address': fetchedItem['address'],
            'primaryContact': fetchedItem['primaryContact'],
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
                            child: Text('Update'),
                            onPressed: _updateForm,
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
          );
        },
      ),
    );
  }
}
