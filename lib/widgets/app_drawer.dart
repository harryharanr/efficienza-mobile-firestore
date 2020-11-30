import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/dashboard.dart';
import '../screens/plant_master/plant_master.dart';
import '../screens/shopfloor_master/shopfloor_master.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello user!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(Dashboard.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.nature),
            title: Text('Plant Master'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(PlantMaster.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shopfloor Master'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ShopfloorMaster.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await _firebaseAuth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
