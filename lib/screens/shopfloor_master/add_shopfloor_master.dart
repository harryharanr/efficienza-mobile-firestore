import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/form-widgets/text-field.dart';
import '../../utils/form-widgets/dropdown.dart';

class AddShopfloorMaster extends StatefulWidget {
  static const routeName = '/add-shopfloor-master';

  @override
  _AddShopfloorMasterState createState() => _AddShopfloorMasterState();
}

class _AddShopfloorMasterState extends State<AddShopfloorMaster> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  final User user = FirebaseAuth.instance.currentUser;

  var _initValues = {
    'plantName': '',
    'address': '',
    'primaryContact': '',
  };

  void _saveForm() async {
    final isValid = _fbKey.currentState.saveAndValidate();

    if (!isValid) {
      return;
    }

    await FirebaseFirestore.instance.collection('shopfloor_master').add(
      {
        'shopfloorName': _fbKey.currentState.value['shopfloorName'],
        'plantName': _fbKey.currentState.value['plantName'],
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
        title: Text('Add Shopfloor'),
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
            'shopfloorName': '',
            'description': '',
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
                      attribute: 'shopfloorName',
                      labelText: 'Shopfloor Name',
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
