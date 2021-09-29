import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phone_number/phone_number.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

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

InputBox nameInput = new InputBox(
  key: 'fullName',
  name: 'Full Name',
  type: FormatType.none,
  ctrl: new TextEditingController(),
);

InputBox phoneInput = new InputBox(
  key: 'phone',
  name: 'Phone Number',
  type: FormatType.phone,
  ctrl: new TextEditingController(),
  lastInput: TextInputAction.done,
);

CheckboxObject newsletterCheckbox = new CheckboxObject(
    text:
        'I would like to sign up for the House of Providence Newsletter in order to get updates on future events.',
    state: true,
    key: 'newsletter');
CheckboxObject volunteerCheckbox = new CheckboxObject(
    text:
        'I would like to volunteer my skills to help House of Providence and the wonderful children we support.',
    state: true,
    key: 'volunteer');

class _RegistrationState extends State<Registration> {
  UserData newUser = new UserData(email: '', pass: '');

  String emailError = '';
  String passError = '';
  String nameError = '';
  String skillsError = '';

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  int currentPage = 0;

  User? currentUser;

  @override
  Widget build(BuildContext context) {
    currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      newUser.uid = currentUser?.uid;
      newUser.creationTime = currentUser?.metadata.creationTime;
      print(currentUser.toString());
    }

    return WillPopScope(
      onWillPop: () async {
        if (currentPage == 0) {
          await FirebaseAuth.instance.signOut();
          return true;
        } else {
          setState(() {
            currentPage--;
          });
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create an Account"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(child: page(currentPage)),
      ),
    );
  }

  Widget page(int page) {
    switch (page) {
      case 0:
        return Column(
          children: [
            heroImage('img/Rectangle32-1.png'),
            registrationIcon(),
            header(),
            Form(
              child: Column(
                children: <Column>[
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
            signInButton(),
          ],
        );
      case 1:
        return Column(
          children: [
            heroImage('img/Rectangle 32-2.png'),
            registrationIcon(),
            header(),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Form(
                child: Column(
                  children: <Column>[
                    _inputBoxSetup(nameInput),
                    _inputBoxSetup(phoneInput),
                  ],
                ),
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
            signInButton(),
          ],
        );
      case 2:
        return Column(
          children: [
            heroImage('img/Rectangle 32-3.png'),
            registrationIcon(),
            header(),
            Form(
              child: Column(
                children: <Widget>[
                  _checkboxSetup(newsletterCheckbox),
                  _checkboxSetup(volunteerCheckbox),
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
            signInButton(),
          ],
        );
      case 3:
        return Column(
          children: [
            heroImage('img/Rectangle 32-4.png'),
            registrationIcon(),
            header(),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Form(
                child: Column(
                  children: <Column>[
                    _inputBoxSetup(nameInput),
                    _inputBoxSetup(phoneInput),
                  ],
                ),
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
            signInButton(),
          ],
        );
      default:
        return Column();
    }
  }

  Widget heroImage(String fileName) {
    return Image.asset(
      fileName,
      fit: BoxFit.cover,
      alignment: Alignment.bottomLeft,
      height: 250,
      width: 800,
    );
  }

  Widget header() {
    return Container(
      child: Text(
        'Registration',
        style: TextStyle(fontSize: 32, color: Colors.blue[900]),
      ),
      padding: const EdgeInsets.only(
        top: 7,
        bottom: 26,
        left: 22,
      ),
      alignment: Alignment.centerLeft,
    );
  }

  Widget newPasswordLink = Container(
    child: Text(
      "Forgot password?",
      style: TextStyle(
        fontSize: 16,
        color: Colors.blue[300],
      ),
    ),
    padding: const EdgeInsets.only(
      left: 22,
      right: 22,
      bottom: 30,
      top: 5,
    ),
    alignment: Alignment.centerRight,
  );

  Widget createAccount = Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account ",
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
    return Container(
      child: ElevatedButton(
        onPressed: () async {
          switch (currentPage) {
            case 0:
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: newUser.email, password: newUser.pass);
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  passError = 'The password provided is too weak.';
                } else if (e.code == 'email-already-in-use') {
                  emailError = 'The account already exists for that email.';
                } else {
                  emailError = 'Invalid Email Address';
                }
                // setState(() {
                //   print(emailError);
                // });
                currentPage--;
              } catch (e) {
                print(e);
              }

              setState(() {
                currentPage++;
              });

              break;

            case 2:
              users.add({
                'Full Name': newUser.fullName,
                'Email': newUser.email,
                'Phone': newUser.phone,
                'Volunteer?': newUser.canVolunteer,
                'Newsletter?': newUser.getNewsletter,
                'uid': newUser.uid,
                'RegistrationDate': newUser.creationTime,
              }).then((value) {
                Navigator.pop(context, true);
                Navigator.pushNamed(context, '/hub');
              }).catchError((error) => print("Failed to add user: $error"));

              break;
            default:
              setState(() {
                currentPage++;
              });
              break;
          }
        },
        child: Text(
          'Next Step',
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
      ),
    );
  }

  Widget registrationIcon() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Image.asset(
        'img/r1.png',
        fit: BoxFit.contain,
        alignment: Alignment.center,
        height: 40,
        width: 60,
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
      case 'fullName':
        text = Text(
          nameError,
          style: textStyle,
        );
        break;
      case 'skills':
        text = Text(
          skillsError,
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
        top: 10,
        left: 35,
        right: 35,
        bottom: 15,
      ),
      child: text,
    );
  }

  Widget _checkboxSetup(CheckboxObject checkbox) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 30),
      child: Row(
        children: [
          Checkbox(
            onChanged: (bool? value) {
              switch (checkbox.key) {
                case 'newsletter':
                  newUser.getNewsletter = value!;
                  break;
                case 'volunteer':
                  newUser.canVolunteer = value!;
                  break;
                default:
              }

              setState(() {
                checkbox.state = value!;
              });
            },
            value: checkbox.state,
          ),
          Expanded(child: Text(checkbox.text)),
        ],
      ),
    );
  }

  Column _inputBoxSetup(InputBox input) {
    MessageObject error = MessageObject(
      message: 'This is a error',
      textColor: Colors.red[200],
    );
    Container errorWidget = _errorMessage(error, input.key);
    RegionInfo region = RegionInfo(name: 'USA', prefix: 1, code: 'US');
    return Column(
      children: [
        Container(
          child: TextFormField(
            controller: input.ctrl,
            autofocus: true,
            textInputAction: input.lastInput,
            onChanged: (val) async {
              switch (input.key) {
                case 'email':
                  {
                    newUser.email = val;
                  }
                  break;
                case 'pass':
                  {
                    print('password typed');
                    if (val.length < 6) {
                      print('password too short');
                      passError = "Password too short";

                      setState(() {
                        errorWidget = _errorMessage(error, input.key);
                        print('text should read: $_errorMessage');
                      });
                    } else {
                      print('password correct length');
                      newUser.pass = val;
                      setState(() {
                        passError = '';
                      });
                    }
                  }
                  break;

                case 'fullName':
                  {
                    newUser.fullName = val;
                  }
                  break;
                case 'phone':
                  {
                    String phoneNumber =
                        val.replaceAll(new RegExp(r'[^0-9]'), ''); // '23'
                    String formattedNumber = '';
                    int chars = phoneNumber.characters.length;
                    print("phoneNumber: $phoneNumber");
                    print("Character: $chars");
                    switch (chars) {
                      case 1:
                        formattedNumber = phoneNumber;
                        break;
                      case 2:
                        formattedNumber = phoneNumber;
                        break;
                      case 3:
                        formattedNumber = phoneNumber;
                        break;
                      case 4:
                        formattedNumber = "(" +
                            phoneNumber.substring(0, 3) +
                            ") " +
                            phoneNumber.substring(3);
                        break;
                      case 5:
                        formattedNumber = "(" +
                            phoneNumber.substring(0, 3) +
                            ") " +
                            phoneNumber.substring(3);
                        break;
                      case 6:
                        formattedNumber = "(" +
                            phoneNumber.substring(0, 3) +
                            ") " +
                            phoneNumber.substring(3);
                        break;
                      case 7:
                        formattedNumber = "(" +
                            phoneNumber.substring(0, 3) +
                            ") " +
                            phoneNumber.substring(3, 6) +
                            " " +
                            phoneNumber.substring(6);
                        break;
                      case 8:
                        formattedNumber = "(" +
                            phoneNumber.substring(0, 3) +
                            ") " +
                            phoneNumber.substring(3, 6) +
                            " " +
                            phoneNumber.substring(6);
                        break;
                      case 9:
                        formattedNumber = "(" +
                            phoneNumber.substring(0, 3) +
                            ") " +
                            phoneNumber.substring(3, 6) +
                            " " +
                            phoneNumber.substring(6);
                        break;
                      case 10:
                        formattedNumber = "(" +
                            phoneNumber.substring(0, 3) +
                            ") " +
                            phoneNumber.substring(3, 6) +
                            " " +
                            phoneNumber.substring(6);
                        break;

                      default:
                        formattedNumber = phoneNumber;
                        if (chars > 10) {
                          formattedNumber = "(" +
                              phoneNumber.substring(0, 3) +
                              ") " +
                              phoneNumber.substring(3, 6) +
                              " " +
                              phoneNumber.substring(6, 10);
                        }
                    }

                    input.ctrl.text = formattedNumber;
                    newUser.phone = formattedNumber;
                    input.ctrl.selection = TextSelection.fromPosition(
                        TextPosition(offset: input.ctrl.text.length));

                    print("Formatted: $formattedNumber");
                  }
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

enum FormatType {
  none,
  phone,
  email,
  password,
}

class CheckboxObject {
  String text = '';
  bool state = true;
  String key = '';

  CheckboxObject({required this.text, required this.state, required this.key});
}

class InputBox {
  String key = '';
  String name = '';
  FormatType type = FormatType.none;
  TextEditingController ctrl;
  TextInputAction lastInput = TextInputAction.next;

  InputBox({
    required this.key,
    required this.name,
    required this.type,
    required this.ctrl,
    this.lastInput = TextInputAction.next,
  });
}

class UserData {
  String? fullName = "";
  String? phone = "";
  String pass = "";
  String email = "";
  bool getNewsletter = true;
  String? skills = "";
  bool canVolunteer = true;
  String? uid;
  DateTime? creationTime;

  UserData({
    required this.email,
    required this.pass,
    this.uid,
    this.fullName,
    this.phone,
    this.getNewsletter = true,
    this.skills,
    this.canVolunteer = true,
    this.creationTime,
  });
}

class MessageObject {
  String message;
  Color? textColor = Colors.red;

  MessageObject({required this.message, this.textColor});
}
