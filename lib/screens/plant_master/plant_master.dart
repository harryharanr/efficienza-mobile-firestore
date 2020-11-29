import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_drawer.dart';
import './add_plant_master.dart';
import './edit_plant_master.dart';

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

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: plantMasterDocs.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      Dismissible(
                        key: ValueKey(plantMasterDocs[index].id),
                        background: Container(
                          color: Theme.of(context).errorColor,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 40,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                        ),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          await FirebaseFirestore.instance
                              .collection('plant_master')
                              .doc(plantMasterDocs[index].id)
                              .delete();
                        },
                        child: ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            child: Text((index + 1).toString()),
                          ),
                          title: Text(plantMasterDocs[index]['plantName']),
                          subtitle: Text(plantMasterDocs[index]['address']),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  EditPlantMaster.routeName,
                                  arguments: plantMasterDocs[index].id);
                            },
                          ),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }),
          );
        },
      ),
    );
  }
}
