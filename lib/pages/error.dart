import 'package:flutter/material.dart';

class Error extends StatefulWidget {
  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<Error> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'House of Providence',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text("House of Providence"),
          ),
          body: Center(
            child: Text("Error..."),
          )),
    );
  }
}
