import 'package:cnc_app/registration_and_login/UserLoginScreen.dart';
import 'package:cnc_app/registration_and_login/UserRegistrationScreen.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.yellow[700], title: Text('Welcome'),automaticallyImplyLeading: false),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      LoginScreen()));
                        },
                        child: Text('Login',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.orange,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                    Flexible(child: SizedBox(width: double.infinity)),
                    Image.asset("assets/images/logo.png",
                        height: 130, width: 130),
                    Flexible(child: SizedBox(width: double.infinity)),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UserRegistrationScreen()));
                        },
                        child: Text('Sign Up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.purple[800],
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                  ],
                ),
              ),

              SizedBox(height: 10),
              Text('News',
                  style: TextStyle(
                      color: Colors.yellow[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 50)),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Container(
                      height: 220,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                AssetImage("assets/images/career.jpeg")),
                            SizedBox(width: 20),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Career Then vs Now',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.orange[800],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Flexible(child: SizedBox(height: 5)),
                                  Text('Team C&C Cell'),
                                  Flexible(child: SizedBox(height: 5)),
                                  Text(
                                    'Contentcontent Contentcontent Contentcontent Contentcontent '
                                        'Contentcontent Contentcontent Contentcontent',
                                    maxLines: null,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}