// import 'package:firebase_core/firebase_core.dart'; // new
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hop_app/main.dart';

class Hub extends StatefulWidget {
  @override
  _HubState createState() => _HubState();
}

class _HubState extends State<Hub> {
  double _test = 90;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
      appBar: AppBar(
        title: Text("House of Providence"),
        backgroundColor: Colors.blue[900],
        actions: <Widget>[
          TextButton(
            style: style,
            onPressed: ()  {
              setState((){ FirebaseAuth.instance.signOut();},);
            },
            child: const Text('Sign Out'),
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: _cardBuilder(
                      "Silent Auction",
                      Colors.black,
                      0.6,
                      "img/hop3.png",
                      Icons.gavel_outlined,
                      'https://app.galabid.com/2021-wishes-gala/',
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: _cardBuilder(
                        "Visit Our Website",
                        Colors.blue,
                        0.6,
                        "img/hop5.png",
                        Icons.web,
                        'https://thehofp.org',
                      )),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: _cardBuilder(
                      "Gala Quiz",
                      Colors.pink.shade900,
                      0.6,
                      "img/hop6.png",
                      Icons.quiz_outlined,
                      'https://quizizz.com/pro/join',
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: _cardBuilder(
                      "Make a Donation",
                      Colors.black,
                      0.5,
                      "img/hop1.png",
                      Icons.money,
                      'https://www.thehofp.org/donations#now',
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: _cardBuilder(
                            "",
                            Colors.blue,
                            0.8,
                            "img/hop2.png",
                            Icons.facebook,
                            'https://www.facebook.com/thehofp/',
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: _cardBuilder(
                            "",
                            Colors.pink.shade900,
                            0.8,
                            "img/hop4.png",
                            Icons.facebook,
                            'https://www.instagram.com/thehofp/?hl=en',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _cardBuilder(
    String text,
    Color color,
    double opacity,
    String picture,
    IconData iconName,
    String url,
  ) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: GestureDetector(
        onTap: () {
          setState(() {
            Navigator.pushNamed(
              context,
              '/browser',
              arguments: ScreenArguments(
                text,
                url,
              ),
            );
          });
        },
        child: Card(
          elevation: _test,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            child: Stack(
              children: [
                ClipRRect(
                  child: Image.asset(
                    picture,
                    fit: BoxFit.cover,
                    height: double.infinity,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                Opacity(
                  opacity: opacity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: color,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        iconName,
                        color: Colors.white,
                        size: 50,
                      ),
                      if (text != "")
                        Text(
                          text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
