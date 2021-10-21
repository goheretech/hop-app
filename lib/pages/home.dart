import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hop_app/pages/registration.dart';

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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    currentUser = FirebaseAuth.instance.currentUser;

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
          ],
        ),
      ),
    );
  }

  Widget heroImage = Image.asset(
    'img/Rectangle32.png',
    fit: BoxFit.cover,
    alignment: Alignment.bottomLeft,
    height: 240,
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
        primary: Colors.pink[700],
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

  Future<bool> authenticateUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
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
