import 'package:flutter/material.dart';

import './dashboard.dart';
import './plant_master/plant_master.dart';
import './plant_master/add_plant_master.dart';
import './plant_master/edit_plant_master.dart';

import './shopfloor_master/shopfloor_master.dart';
import './shopfloor_master/add_shopfloor_master.dart';
import './shopfloor_master/edit_shopfloor_master.dart';

import './shift_master/shift_master.dart';
import './shift_master/add_shift_master.dart';
import './shift_master/edit_shift_master.dart';

import './routine_master/routine_master.dart';
import './routine_master/add_routine_master.dart';
import './routine_master/edit_routine_master.dart';

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
        ShopfloorMaster.routeName: (ctx) => ShopfloorMaster(),
        AddShopfloorMaster.routeName: (ctx) => AddShopfloorMaster(),
        EditShopfloorMaster.routeName: (ctx) => EditShopfloorMaster(),
        ShiftMaster.routeName: (ctx) => ShiftMaster(),
        AddShiftMaster.routeName: (ctx) => AddShiftMaster(),
        EditShiftMaster.routeName: (ctx) => EditShiftMaster(),
        RoutineMaster.routeName: (ctx) => RoutineMaster(),
        AddRoutineMaster.routeName: (ctx) => AddRoutineMaster(),
        EditRoutineMaster.routeName: (ctx) => EditRoutineMaster(),
      },
    );
  }
}
