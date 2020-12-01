import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
      body: StaggeredGridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 12.0,
        padding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        children: <Widget>[
          myItems(40, "Plants", Colors.red),
          myItems(5, "Shopfloors", Colors.indigo),
          myItems(60, "Shifts", Colors.green),
          myItems(7, "Departments", Colors.lightBlueAccent),
          myItems(8, "Routines", Colors.orange),
          myItems(9, "Assets", Colors.pinkAccent),
          myItems(35, "Operations", Colors.brown),
          myItems(35, "UoM", Colors.redAccent),
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 140.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(1, 150.0),
          StaggeredTile.extent(2, 140.0),
        ],
      ),
    );
  }

  Widget myItems(int value, String title, Color color) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              value.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
          ],
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
  // Material myItems(int value, String title, Color color) {
  //   return Material(
  //     color: Colors.white,
  //     elevation: 14.0,
  //     shadowColor: Color(0X802196F3),
  //     borderRadius: BorderRadius.circular(24.0),
  //     child: Center(
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Text(
  //                     title,
  //                     style: TextStyle(
  //                       color: color,
  //                       fontSize: 20,
  //                     ),
  //                   ),
  //                 ),
  //                 CircleAvatar(
  //                   child: Text(
  //                     value.toString(),
  //                     style: TextStyle(
  //                       fontSize: 30,
  //                     ),
  //                   ),
  //                   backgroundColor: color,
  //                   radius: 30,
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
