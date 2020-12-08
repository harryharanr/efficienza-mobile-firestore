import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_drawer.dart';
import './add_routine_master.dart';
import './edit_routine_master.dart';

class RoutineMaster extends StatelessWidget {
  static const routeName = '/routine-master';
  final User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Routine Master'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddRoutineMaster.routeName);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('routine_master')
            .where('createdBy', isEqualTo: user.uid)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> routineMasterSnapshot) {
          if (routineMasterSnapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (routineMasterSnapshot.data.docs.length == 0) {
            return Center(
              child: Text(
                'No Routine has been added yet!',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final routineMasterDocs = routineMasterSnapshot.data.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: routineMasterDocs.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      Dismissible(
                        key: ValueKey(routineMasterDocs[index].id),
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
                              .collection('routine_master')
                              .doc(routineMasterDocs[index].id)
                              .delete();
                        },
                        child: ListTile(
                          onTap: () {},
                          leading: CircleAvatar(
                            child: Text((index + 1).toString()),
                          ),
                          title: Text(routineMasterDocs[index]['routineName']),
                          subtitle: Text(
                              routineMasterDocs[index]['routineFrequency']),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  EditRoutineMaster.routeName,
                                  arguments: routineMasterDocs[index].id);
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
