import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Loading Screen'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
