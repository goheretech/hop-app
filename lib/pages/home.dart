import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hop_app/pages/registration.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

InputBox emailInput = new InputBox(
  key: 'email',
  name: 'Email Address',
  type: FormatType.none,
  ctrl: new TextEditingController(),
);

InputBox passInput = new InputBox(
  key: 'pass',
  name: 'Password',
  type: FormatType.password,
  ctrl: new TextEditingController(),
  lastInput: TextInputAction.done,
);

String emailError = '';
String passError = '';
User? currentUser;
UserData form = new UserData(email: '', pass: '');

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = auth;

Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      print("Google sign-in successful for user: ${user?.email}");
      return user;
    } else {
      print("Google sign-in account is null");
      return null;
    }
  } catch (error) {
    print("Error during Google sign-in: $error");
    return null;
  }
}

Future<bool> authenticateUser() async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: form.email,
      password: form.pass,
    );
    print(userCredential);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
    return false;
  }
  return true;
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    currentUser = _auth.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            heroImage,
            logo,
            Form(
              child: Column(
                children: <Widget>[
                  _inputBoxSetup(emailInput),
                  _inputBoxSetup(passInput),
                ],
              ),
            ),
            // Consumer<ApplicationState>(
            //   builder: (context, appState, _) => Authentication(
            //     email: appState.email,
            //     loginState: appState.loginState,
            //     startLoginFlow: appState.startLoginFlow,
            //     verifyEmail: appState.verifyEmail,
            //     signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
            //     cancelRegistration: appState.cancelRegistration,
            //     registerAccount: appState.registerAccount,
            //     signOut: appState.signOut,
            //   ),
            // ),
            newPasswordLink,
            signInButton(),

            GestureDetector(
              onTap: () => {
                setState(() {
                  Navigator.pushNamed(
                    context,
                    '/registration',
                  );
                })
              },
              child: createAccount,
            ),
            thirdPartyLogin(),
          ],
        ),
      ),
    );
  }

  Widget heroImage = Image.asset(
    'img/Rectangle32.png',
    fit: BoxFit.cover,
    alignment: Alignment.bottomLeft,
    height: 180,
    width: 800,
  );

  Widget logo = Container(
    child: Image.asset(
      "img/Logo.png",
      width: 250,
    ),
    padding: const EdgeInsets.only(
      top: 18,
      bottom: 23,
      left: 10,
    ),
    alignment: Alignment.centerLeft,
  );

  Widget newPasswordLink = Container(
    child: Text(
      "Forgot password?",
      style: TextStyle(
        fontSize: 14,
        color: Colors.blue[300],
      ),
    ),
    padding: const EdgeInsets.only(
      left: 22,
      right: 22,
      bottom: 25,
      top: 0,
    ),
    alignment: Alignment.centerRight,
  );

  Widget createAccount = Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        Text(
          "Signup",
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue[300],
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
    padding: const EdgeInsets.only(
      left: 22,
      right: 22,
      bottom: 30,
      top: 30,
    ),
    alignment: Alignment.center,
  );

  Column thirdPartyLogin() {
    return Column(children: [
      googleSignInButton(context: context),
      if (Platform.isIOS) SizedBox(height: 10),
      if (Platform.isIOS) appleSignInButton(context: context)
    ]);
  }

  Widget signInButton() {
    return ElevatedButton(
      onPressed: () {
        authenticateUser().then((success) {
          if (success) {
            Navigator.pushReplacementNamed(
              context,
              '/hub',
            );
          }
        });
      },
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink[700],
        fixedSize: Size(
          320,
          50,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Container _errorMessage(MessageObject error, String variable) {
    var textStyle = TextStyle(
      color: error.textColor,
      fontSize: 12,
    );

    var text = Text('');

    switch (variable) {
      case 'email':
        text = Text(
          emailError,
          style: textStyle,
        );
        break;
      case 'pass':
        text = Text(
          passError,
          style: textStyle,
        );
        break;

      default:
        text = Text(
          '',
          style: textStyle,
        );
    }

    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(
        top: 5,
        left: 35,
        right: 35,
        bottom: 15,
      ),
      child: text,
    );
  }

  Column _inputBoxSetup(InputBox input) {
    MessageObject error = MessageObject(
      message: 'This is a error',
      textColor: Colors.red[200],
    );
    Container errorWidget = _errorMessage(error, input.key);
    return Column(
      children: [
        Container(
          child: TextFormField(
            controller: input.ctrl,
            // autofocus: true,
            textInputAction: input.lastInput,
            onChanged: (val) async {
              // PhoneNumber formatted = await PhoneNumberUtil().parse(val);

              // setState(() {
              //   input.ctrl.text = formatted.national;

              //   input.ctrl.selection = TextSelection.fromPosition(
              //       TextPosition(offset: input.ctrl.text.length));
              //   print(formatted);
              // });

              switch (input.key) {
                case 'email':
                  {
                    form.email = val;
                  }
                  break;
                case 'pass':
                  {
                    form.pass = val;
                    setState(() {
                      passError = '';
                    });
                  }

                  break;
              }
            },
            style: TextStyle(
              color: Colors.grey[600],
            ),
            obscureText: input.type == FormatType.password,
            decoration: InputDecoration(
              labelText: input.name,
            ),
          ),
          width: 360,
          margin: const EdgeInsets.only(
            left: 32,
            right: 32,
          ),
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(
              color: (Colors.white),
              width: 0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        errorWidget,
      ],
    );
  }
}

class googleSignInButton extends StatelessWidget {
  const googleSignInButton({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        debugPrint('Signing in with Google');
        signInWithGoogle().then((success) {
          if (success != null) {
            debugPrint('Signing in with Google successful');
            Navigator.pushReplacementNamed(
              context,
              '/hub',
            );
          } else {
            debugPrint('Signing in with Google failed');
          }
        });
        ;
      },
      icon: Image.asset(
        'img/google_logo.png', // You need to add this asset. See step 3.
        height: 24.0,
      ),
      label: Text(
        'Continue with Google',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: Size(
          320,
          50,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class appleSignInButton extends StatelessWidget {
  const appleSignInButton({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: appleCredential.identityToken,
          accessToken: appleCredential.authorizationCode,
        );
        await _auth.signInWithCredential(credential);
      },
      icon: Image.asset(
        'img/apple_logo.png', // You need to add this asset. See step 3.
        height: 24.0,
      ),
      label: Text(
        'Continue with Apple',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        fixedSize: Size(
          320,
          50,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
