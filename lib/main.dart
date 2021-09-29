import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hop_app/pages/loading.dart';
import 'package:hop_app/pages/error.dart';
import 'package:hop_app/pages/home.dart';
import 'package:hop_app/pages/hub.dart';
import 'package:hop_app/pages/browser.dart';
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
      },
    ),
  );
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
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
    // Show error message if initialization failed
    if (_error) {
      return Error();
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      print('Loading..');
      return Loading();
    }
    print('Loaded');
    firebaseTest();
    return Home();
  }

  void firebaseTest() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');

        FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: user.uid)
            .get()
            .then((s) {
          int v = s.docs.length;
          print(v);
          if (v > 0) {
            Navigator.pushNamed(context, '/hub');
          } else {
            // FirebaseAuth.instance.signOut();
          }
        });
      }
    });
  }
}

class ScreenArguments {
  final String title;
  final String url;

  ScreenArguments(this.title, this.url);
}
