import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../utils/form-widgets/text-field.dart';
import '../../utils/form-widgets/dropdown.dart';

class EditShopfloorMaster extends StatefulWidget {
  static const routeName = '/edit-shopfloor-master';

  @override
  _EditShopfloorMasterState createState() => _EditShopfloorMasterState();
}

class _EditShopfloorMasterState extends State<EditShopfloorMaster> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  final User user = FirebaseAuth.instance.currentUser;

  var _initValues = {
    'shopfloorName': '',
    'plantName': '',
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
        .collection('shopfloor_master')
        .doc(itemId)
        .update(
      {
        'plantName': _fbKey.currentState.value['plantName'],
        'shopfloorName': _fbKey.currentState.value['shopfloorName'],
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
        title: Text('Edit Shopfloor Screen'),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('shopfloor_master')
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

          if (fetchedItem['plantName'] != null) {
            _initValues = {
              'plantName': fetchedItem['plantName'],
              'shopfloorName': fetchedItem['shopfloorName'],
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
                        buildTextField(
                          attribute: 'shopfloorName',
                          labelText: 'Shopfloor Name',
                        ),
                        SizedBox(height: 20),
                        buildDropdown(
                          attribute: 'plantName',
                          labelText: 'Plant',
                          hintText: 'Select a plant',
                          options: plantLists,
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
