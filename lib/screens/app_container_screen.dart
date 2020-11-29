import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './auth_screen.dart';
import './dashboard.dart';
import './plant_master/plant_master.dart';
import './plant_master/add_plant_master.dart';
import './plant_master/edit_plant_master.dart';
import './loading_screen.dart';
import './error_screen.dart';

class AppContainerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Efficienza Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.pink,
        accentColor: Colors.deepPurple,
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: Dashboard(),
      routes: {
        Dashboard.routeName: (ctx) => Dashboard(),
        PlantMaster.routeName: (ctx) => PlantMaster(),
        AddPlantMaster.routeName: (ctx) => AddPlantMaster(),
        EditPlantMaster.routeName: (ctx) => EditPlantMaster(),
      },
    );
  }
}
