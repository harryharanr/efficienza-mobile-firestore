import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/form-widgets/text-field.dart';
import '../../utils/form-widgets/dropdown.dart';
import '../../utils/form-widgets/time-picker.dart';

class EditShiftMaster extends StatefulWidget {
  static const routeName = '/edit-shift-master';

  @override
  _EditShiftMasterState createState() => _EditShiftMasterState();
}

class _EditShiftMasterState extends State<EditShiftMaster> {
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
        .collection('shift_master')
        .doc(itemId)
        .update(
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
        'createdBy': user.uid,
      },
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Shift Master'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('shift_master')
            .doc(itemId)
            .get(),
        builder: (ctx, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return Center(
              child: Text('No data found!'),
            );
          }
          final fetchedItem = snapshot.data.data();

          if (fetchedItem['plantName'] != null) {
            _initValues = {
              'plantName': fetchedItem['plantName'],
              'shiftName': fetchedItem['shiftName'],
              'shiftStartTime': fetchedItem['shiftStartTime'] != null
                  ? fetchedItem['shiftStartTime']
                  : DateTime.now(),
              'shiftEndTime': fetchedItem['shiftEndTime'] != null
                  ? fetchedItem['shiftEndTime']
                  : DateTime.now(),
              'breakName': fetchedItem['breakName'],
              'breakStartTime': fetchedItem['breakStartTime'] != null
                  ? fetchedItem['breakStartTime']
                  : DateTime.now(),
              'breakEndTime': fetchedItem['breakEndTime'] != null
                  ? fetchedItem['breakEndTime']
                  : DateTime.now(),
              'description': fetchedItem['description'],
            };
          }
          return FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('plant_master')
                .where('createdBy', isEqualTo: user.uid)
                .get(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> plantMastersnapshot) {
              if (plantMastersnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (plantMastersnapshot.data == null) {
                return Center(
                  child: Text('No data found!'),
                );
              }
              final List<Map<String, String>> plantLists = [];
              final fetchedPlantItems = plantMastersnapshot.data.docs;

              fetchedPlantItems.forEach((element) {
                plantLists.add(
                    {'id': element.id, 'displayName': element['plantName']});
              });

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
                          hintText: 'Select a plant',
                          attribute: 'plantName',
                          labelText: 'Plant',
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
                                initialValue: _initValues['shiftStartTime'],
                                attribute: 'shiftStartTime',
                                labelText: 'Shift Start Time',
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: buildTimePicker(
                                initialValue: _initValues['shiftEndTime'],
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
                                initialValue: _initValues['breakStartTime'],
                                attribute: 'breakStartTime',
                                labelText: 'Break Start Time',
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: buildTimePicker(
                                initialValue: _initValues['breakEndTime'],
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
          );
        },
      ),
    );
  }
}
