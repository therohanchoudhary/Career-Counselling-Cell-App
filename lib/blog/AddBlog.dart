import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnc_app/UserHomeScreen.dart';
import 'package:cnc_app/utility/ClassicButton.dart';
import 'package:cnc_app/utility/UsefulMethods.dart';
import 'package:flutter/material.dart';

class AddBlogScreen extends StatefulWidget {
  @override
  _AddBlogScreenState createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  String _title;
  String _content;
  String _name;
  bool _showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Add Blog'), backgroundColor: Colors.yellow[700]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 50,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
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
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
                    hintText: 'Your name',
                    fillColor: Colors.grey[300]),
                onChanged: (text) {
                  setState(() {
                    _name = text;
                  });
                },
              ),
            ), //
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: 50,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
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
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
                    hintText: 'Title',
                    fillColor: Colors.grey[300]),
                onChanged: (text) {
                  setState(() {
                    _title = text;
                  });
                },
              ),
            ), // title
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
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
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
                    hintText: 'Content',
                    fillColor: Colors.grey[300]),
                onChanged: (text) {
                  setState(() {
                    _content = text;
                  });
                },
              ),
            ), // content
            SizedBox(height: 30),
            _showLoading
                ? Center(child: CircularProgressIndicator())
                : GestureDetector(
                    onTap: () async {
                      setState(() {
                        _showLoading = true;
                      });
                      if (_title != null &&
                          _title != "" &&
                          _name != null &&
                          _name != "" &&
                          _content != null &&
                          _content != "") {
                        try {
                          var firestoreInstance =
                              FirebaseFirestore.instance.collection("blog");
                          String id;

                          await firestoreInstance.add({
                            "author": _name,
                            "accept": 0,
                            "title": _title,
                            "content": _content,
                            "views": 0,
                            "blogUID": "",
                            "pic1": "",
                            "pic2": "",
                          }).then((value) {
                            id = value.id;
                            print(value.id);
                          });

                          if (id != null || id != "") {
                            await firestoreInstance
                                .doc(id)
                                .update({'blogUID': id});

                            await FirebaseFirestore.instance
                                .collection("blog")
                                .doc(id)
                                .collection("comments")
                                .add({
                              "name": "test",
                              "email": "test",
                              "comment": "test"
                            });
                          }

                          UsefulMethods().showToastLong(
                              "Your blog has been submitted under review.");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      UserHomeScreen()));
                        } catch (e) {
                          UsefulMethods().showToast("An error occurred: $e");
                        }
                      } else {
                        UsefulMethods().showToast("Incomplete Details");
                      }
                      setState(() {
                        _showLoading = false;
                      });
                    },
                    child: ClassicButtonContainer(
                        text: "Submit", color: Colors.orange)),
          ],
        ),
      ),
    );
  }
}
