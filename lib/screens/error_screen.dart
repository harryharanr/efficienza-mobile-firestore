import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Error Screen',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Error Screen'),
        ),
        body: Center(
          child: Text('Error occured!!'),
        ),
      ),
    );
  }
}
