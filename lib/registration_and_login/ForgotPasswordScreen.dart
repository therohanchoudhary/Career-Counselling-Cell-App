import 'package:cnc_app/starting_screens/IntroScreen.dart';
import 'package:cnc_app/utility/ClassicButton.dart';
import 'package:cnc_app/utility/UsefulMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController email = TextEditingController();
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: TextField(
                  controller: email,
                ),
              ),
              showSpinner
                  ? CircularProgressIndicator(color: Colors.orange)
                  : GestureDetector(
                onTap: () async {
                  setState(() {
                    showSpinner = true;
                  });

                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email.text);
                    UsefulMethods().showToastLong(
                        "Check your email id for further instructions.");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                IntroScreen()));
                  } catch (e) {
                    UsefulMethods()
                        .showToast("Invalid Email Address Entered");
                  }

                  setState(() {
                    showSpinner = false;
                  });
                },
                child: ClassicButtonContainer(
                    text: 'Send Email', color: Colors.purple[800]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}