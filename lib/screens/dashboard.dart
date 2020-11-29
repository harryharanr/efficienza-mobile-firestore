import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class Dashboard extends StatelessWidget {
  static const routeName = '/dashboard';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Text('Dashboard'),
      ),
    );
  }
}
