import 'package:cnc_app/UserHomeScreen.dart';
import 'package:cnc_app/registration_and_login/UserRegistrationScreen.dart';
import 'package:cnc_app/utility/ClassicButton.dart';
import 'package:cnc_app/utility/UsefulMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ForgotPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailEntered = TextEditingController();
  TextEditingController passwordEntered = TextEditingController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 25),
              Container(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/logo.png')),
              SizedBox(height: 25),
              Center(
                  child: Text('LOGIN',
                      style: TextStyle(
                          color: Colors.yellow[700],
                          fontSize: 30,
                          fontWeight: FontWeight.bold))),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  maxLines: 1,
                  controller: emailEntered,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow[700], width: 2.0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.grey[300], width: 2.0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      filled: true,
                      isDense: true,
                      contentPadding: EdgeInsets.all(20),
                      hintStyle:
                      TextStyle(color: Colors.grey[500], fontSize: 12),
                      hintText: 'Email ID',
                      fillColor: Colors.grey[300]),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  maxLines: 1,
                  controller: passwordEntered,
                  obscureText: true,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow[700], width: 2.0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.grey[300], width: 2.0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      filled: true,
                      isDense: true,
                      contentPadding: EdgeInsets.all(20),
                      hintStyle:
                      TextStyle(color: Colors.grey[500], fontSize: 12),
                      hintText: 'Password',
                      fillColor: Colors.grey[300]),
                ),
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailEntered.text,
                        password: passwordEntered.text);

                    setState(() {
                      showSpinner = false;
                    });

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                UserHomeScreen()));
                  } on FirebaseAuthException catch (e) {
                    print(e);
                    setState(() {
                      showSpinner = false;
                    });
                    UsefulMethods()
                        .showToast("Please enter correct credentials");
                  }
                },
                child: showSpinner == false
                    ? ClassicButtonContainer(
                    text: 'Login', color: Colors.yellow[700])
                    : CircularProgressIndicator(color: Colors.yellow[700]),
              ),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ForgotPasswordScreen()));
                  },
                  child: Text('Forgot Password',style: TextStyle(color: Colors.purple[800]))),
              SizedBox(height: 80),
              Center(
                  child: Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  )),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              UserRegistrationScreen()));
                },
                child: Center(
                    child: Text(
                      "Create account",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.purple[800],
                          decoration: TextDecoration.underline),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}