import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/app_drawer.dart';
import './add_shift_master.dart';
import './edit_shift_master.dart';

class ShiftMaster extends StatelessWidget {
  static const routeName = '/shift-master';

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Shift Master'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddShiftMaster.routeName);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shift_master')
            .where('createdBy', isEqualTo: user.uid)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> shiftMasterSnapshot) {
          if (shiftMasterSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (shiftMasterSnapshot.data.docs.length == 0) {
            return Center(
              child: Text(
                'No Shift has been added yet!',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final shiftMasterDocs = shiftMasterSnapshot.data.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: shiftMasterDocs.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      Dismissible(
                        key: ValueKey(shiftMasterDocs[index].id),
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
                              .collection('shift_master')
                              .doc(shiftMasterDocs[index].id)
                              .delete();
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text((index + 1).toString()),
                          ),
                          title: Text(shiftMasterDocs[index]['shiftName']),
                          subtitle: Text(shiftMasterDocs[index]['description']),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  EditShiftMaster.routeName,
                                  arguments: shiftMasterDocs[index].id);
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
