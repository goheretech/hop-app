import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     
      home: Scaffold(
          
          body: Center(
            child: Text("Loading..."),
          )),
    );
  }
}
