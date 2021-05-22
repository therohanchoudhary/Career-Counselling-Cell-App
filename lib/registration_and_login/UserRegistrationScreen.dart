import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnc_app/UserHomeScreen.dart';
import 'package:cnc_app/registration_and_login/UserLoginScreen.dart';
import 'package:cnc_app/utility/ClassicButton.dart';
import 'package:cnc_app/utility/UserRegisterDetailClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utility/UsefulMethods.dart';

class UserRegistrationScreen extends StatefulWidget {
  @override
  _UserRegistrationScreen createState() => _UserRegistrationScreen();
}

class _UserRegistrationScreen extends State<UserRegistrationScreen> {
  bool _showProgressIndicator = false;

  UserRegisterDetailClass userRegistered;

  TextEditingController nameEntered = TextEditingController();
  TextEditingController emailEntered = TextEditingController();
  TextEditingController mobileNumberEntered = TextEditingController();
  TextEditingController passwordEntered = TextEditingController();
  TextEditingController confirmPasswordEntered = TextEditingController();
  TextEditingController jobProfileEntered = TextEditingController();

  DateTime dateOfBirth = DateTime.now();
  String genderEntered = '';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime pickedDate = await showDatePicker(
        context: context,
        initialDate: dateOfBirth,
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != dateOfBirth)
      setState(() {
        dateOfBirth = pickedDate;
      });
  }

  _input(String hintText, double height, int maxLines, var keyboardType,
      var controller) {
    FocusNode myFocusNode = new FocusNode();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        height: height,
        child: TextFormField(
          focusNode: myFocusNode,
          obscureText:
              (hintText == 'Password' || hintText == 'Confirm Password'),
          maxLines: maxLines,
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange, width: 2.0),
                borderRadius: BorderRadius.circular(40),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300], width: 5.0),
                borderRadius: BorderRadius.circular(40),
              ),
              filled: true,
              isDense: true,
              contentPadding: EdgeInsets.all(20),
              hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
              labelText: hintText,
              labelStyle: TextStyle(
                color: Colors.black,
              ),
              alignLabelWithHint: true,
              fillColor: Colors.grey[300]),
        ),
      ),
    );
  }

  String _checkRegistrationDetails() {
    if (passwordEntered.text != confirmPasswordEntered.text) {
      return 'Passwords not Matching';
    }

    if (passwordEntered.text.length < 8) {
      return 'Please enter a strong password';
    }
    if (DateTime.now().difference(dateOfBirth).inDays < 6573) {
      print(dateOfBirth.difference(DateTime.now()).inDays);
      return 'You must be 18 years old to register';
    }
    if (genderEntered == '') {
      return 'No Gender Entered';
    }
    if (nameEntered.text == '' ||
        nameEntered.text == null ||
        jobProfileEntered.text == '' ||
        jobProfileEntered.text == null ||
        emailEntered.text == '' ||
        emailEntered.text == null ||
        mobileNumberEntered.text.length < 5) {
      return 'Insufficient details entered';
    }
    return '';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                Container(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
                SizedBox(height: 25),
                Text('Register',
                    style: TextStyle(
                        color: Colors.yellow[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 25)),
                Text('Please fill all the details for registration',
                    style: TextStyle(color: Colors.black, fontSize: 12)),
                SizedBox(height: 30),
                _input('Name', 80, 1, TextInputType.name, nameEntered),
                _input('Email Id', 80, 1, TextInputType.emailAddress,
                    emailEntered),
                _input('Mobile Number', 80, 1, TextInputType.number,
                    mobileNumberEntered),
                SizedBox(height: 18),
                _input('Current Professional Role', 300, null, TextInputType.multiline,
                    jobProfileEntered),
                Center(
                  child: DropdownButton<String>(
                    hint: Text(
                        genderEntered != '' ? genderEntered : 'Select Gender'),
                    items:
                        <String>['Male', 'Female', 'Other'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        genderEntered = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow[700], // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () => _selectDate(context),
                  child: Text(dateOfBirth != DateTime.now()
                      ? 'Date of Birth: ${dateOfBirth.toString().substring(0, 10)}'
                      : 'Select Date of Birth'),
                ),
                SizedBox(height: 20),
                _input('Password', 80, 1, TextInputType.visiblePassword,
                    passwordEntered),
                _input('Confirm Password', 80, 1, TextInputType.visiblePassword,
                    confirmPasswordEntered),
                SizedBox(height: 30),
                GestureDetector(
                  onTap: () async {
                    try {
                      setState(() {
                        _showProgressIndicator = true;
                      });

                      String registrationError = _checkRegistrationDetails();
                      if (registrationError == '') {
                        userRegistered = UserRegisterDetailClass(
                          name: nameEntered.text,
                          gender: genderEntered,
                          email: emailEntered.text,
                          password: passwordEntered.text,
                          mobileNumber: mobileNumberEntered.text,
                          dob: dateOfBirth.toString().substring(0, 10),
                        );

                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailEntered.text,
                          password: passwordEntered.text,
                        );

                        await FirebaseFirestore.instance
                            .collection("users")
                            .doc(emailEntered.text)
                            .set({
                          "name": nameEntered.text,
                          "email": emailEntered.text,
                          "mobileNumber": mobileNumberEntered.text,
                          "profession": jobProfileEntered.text,
                          "dob": "$dateOfBirth",
                          "password": passwordEntered.text,
                          "gender": "$genderEntered"
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    UserHomeScreen()));
                      } else
                        UsefulMethods().showToast(registrationError);

                      setState(() {
                        _showProgressIndicator = false;
                      });
                    } catch (e) {
                      print(e);
                      setState(() {
                        _showProgressIndicator = false;
                      });
                      UsefulMethods()
                          .showToast("Please enter correct credentials.");
                    }
                  },
                  child: _showProgressIndicator == false
                      ? ClassicButtonContainer(
                          text: 'Register', color: Colors.purple[800])
                      : CircularProgressIndicator(),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen())),
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(
                        fontSize: 10,
                        color: Colors.yellow[700],
                        decoration: TextDecoration.underline),
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
