import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../widgets/app_drawer.dart';
import './add_shopfloor_master.dart';
import './edit_shopfloor_master.dart';

class ShopfloorMaster extends StatelessWidget {
  static const routeName = '/shopfloor-master';

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Shopfloor Master'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddShopfloorMaster.routeName);
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shopfloor_master')
            .where('createdBy', isEqualTo: user.uid)
            .snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> shopfloorMasterSnapshot) {
          if (shopfloorMasterSnapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (shopfloorMasterSnapshot.data.docs.length == 0) {
            return Center(
              child: Text(
                'No Shopfloor has been added yet!',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final shopfloorMasterDocs = shopfloorMasterSnapshot.data.docs;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: shopfloorMasterDocs.length,
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      Dismissible(
                        key: ValueKey(shopfloorMasterDocs[index].id),
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
                              .collection('shopfloor_master')
                              .doc(shopfloorMasterDocs[index].id)
                              .delete();
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text((index + 1).toString()),
                          ),
                          title:
                              Text(shopfloorMasterDocs[index]['shopfloorName']),
                          subtitle:
                              Text(shopfloorMasterDocs[index]['plantName']),
                          trailing: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  EditShopfloorMaster.routeName,
                                  arguments: shopfloorMasterDocs[index].id);
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
