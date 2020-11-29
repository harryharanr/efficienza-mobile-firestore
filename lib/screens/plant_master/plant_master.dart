import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_drawer.dart';
import './add_plant_master.dart';

class PlantMaster extends StatelessWidget {
  static const routeName = '/plant-master';

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Plant Master'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlantMaster.routeName);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('plant_master')
            .where('createdBy', isEqualTo: user.uid)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> plantMasterSnapshot) {
          if (plantMasterSnapshot.connectionState == ConnectionState.waiting ||
              plantMasterSnapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final plantMasterDocs = plantMasterSnapshot.data.docs;

          return ListView.builder(
            itemCount: plantMasterDocs.length,
            itemBuilder: (ctx, index) => Text(
              plantMasterDocs[index]['plantName'],
            ),
          );
        },
      ),
    );
  }
}
