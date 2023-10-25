// import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hop_app/main.dart';
import '/screen_arguments.dart';

class Hub extends StatefulWidget {
  @override
  _HubState createState() => _HubState();
}

class _HubState extends State<Hub> {
  double _test = 90;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.primary);
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'img/uechah.png', // Path to your asset
            height: AppBar().preferredSize.height -
                20, // Adjust the height as needed
            fit: BoxFit.fitHeight,
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(),
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text('Sign Out'),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _cardBuilder(
                  "Make a Donation",
                  Color.fromARGB(255, 56, 82, 130),
                  0.9,
                  "img/hop2.png",
                  "img/icon-donate.png",
                  'https://hopearmy.org/donations',
                  true),
              _cardBuilder(
                  "Silent Auction",
                  Color.fromARGB(255, 101, 50, 140),
                  0.9,
                  "img/hop1.png",
                  "img/icon-silent.png",
                  'https://givebutter.com/c/rgMVzE/auction',
                  false),
              _cardBuilder(
                  "Digital Program",
                  Color.fromARGB(255, 27, 109, 120),
                  0.9,
                  "img/hop4.png",
                  "img/icon-program.png",
                  'https://hopearmy.org/program/gala-2023',
                  true),
              _cardBuilder(
                  "Get Involved",
                  Color.fromARGB(255, 245, 172, 23),
                  0.9,
                  "img/hop3.png",
                  "img/icon-involved.png",
                  'https://www.hopearmy.org/take-action',
                  false),
              _cardBuilder(
                  "Learn more",
                  Color.fromARGB(255, 221, 76, 45),
                  0.9,
                  "img/hop3.png",
                  "img/uechah.png",
                  'https://www.hopearmy.org/about-us',
                  true),
            ],
          ),
        ));
  }

  Container _cardBuilder(
    String text,
    Color color,
    double opacity,
    String picture,
    String iconName,
    String url,
    bool textLeft,
  ) {
    return Container(
      width: double.infinity,
      height: 200,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/browser',
            arguments: ScreenArguments(
              text,
              url,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: Card(
            // Removed elevation property
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  // Added boxShadow here
                  BoxShadow(
                    color: Colors.black.withOpacity(0.13),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    child: Image.asset(picture,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  Opacity(
                    opacity: opacity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 10),
                        if (textLeft == true)
                          Image.asset(iconName,
                              width: 100, height: double.infinity),
                        SizedBox(width: 20),
                        if (text != "")
                          Flexible(
                              child: Text(
                            text.toUpperCase(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: color,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 2.0,
                                  color: Color.fromARGB(16, 0, 0, 0),
                                ),
                              ],
                            ),
                          )),
                        if (textLeft == false) SizedBox(width: 20),
                        if (textLeft == false)
                          Image.asset(iconName,
                              width: 100, height: double.infinity),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
