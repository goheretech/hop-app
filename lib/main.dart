import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hop_app/pages/loading.dart';
import 'package:hop_app/pages/error.dart';
import 'package:hop_app/pages/home.dart';
import 'package:hop_app/pages/hub.dart';
import 'package:hop_app/pages/browser.dart';
import 'package:hop_app/pages/program.dart';
import 'package:hop_app/pages/registration.dart';

FirebaseAuth auth = FirebaseAuth.instance;
CollectionReference users = FirebaseFirestore.instance.collection('users');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => App(),
        '/home': (context) => Home(),
        '/registration': (context) => Registration(),
        '/hub': (context) => Hub(),
        '/browser': (context) => Browser(),
        '/program': (context) => Program(),
      },
    ),
  );
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Error();
    }

    if (!_initialized) {
      return Loading();
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Hub(); // Display the hub when the user is logged in
        }
        return Home(); // Display the login/signup screen otherwise
      },
    );
  }
}
