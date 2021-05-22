import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnc_app/utility/ClassicButton.dart';
import 'package:cnc_app/utility/CommentClass.dart';
import 'package:cnc_app/utility/UsefulMethods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SingleArticleScreen extends StatefulWidget {
  final String title;
  final String author;
  final String content;
  final String pic1;
  final String pic2;
  final int views;
  final String blogID;

  SingleArticleScreen(
      {this.content,
      this.author,
      this.title,
      this.pic1,
      this.pic2,
      this.views,
      this.blogID});

  @override
  _SingleArticleScreenState createState() => _SingleArticleScreenState();
}

class _SingleArticleScreenState extends State<SingleArticleScreen> {
  List<Comment> comments = [];
  TextEditingController _commentEntered = TextEditingController();
  String readerEmail = "";
  String readerName = "";
  bool _commentSpinner = false;

  _getComments() async {
    print(widget.blogID);
    await FirebaseFirestore.instance
        .collection("blog")
        .doc(widget.blogID)
        .collection("comments")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var curr = doc.data();
        print("778798797645342657687980");
        comments.add(Comment(
            name: curr["name"],
            comment: curr["comment"],
            email: curr["email"]));
      });
    });
    setState(() {});
  }

  _getReaderDetails() async {
    var auth = FirebaseAuth.instance.currentUser;
    readerEmail = auth.email;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(readerEmail)
        .get()
        .then((value) => {readerName = value.data()["name"]});
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getComments();
    _getReaderDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(widget.pic1, width: double.infinity),
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(widget.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 38.0),
              child: Row(
                children: [
                  Image.asset("assets/images/logo.png", height: 70, width: 70),
                  SizedBox(width: 20),
                  Text(
                    widget.author,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 38.0),
              child: Text(widget.content,
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            SizedBox(height: 20),
            widget.pic2 != null
                ? Image.network(widget.pic2, width: double.infinity)
                : Container(),
            SizedBox(height: 50),
            Column(children: [
              Text('Comments',
                  style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 28)),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  child: TextFormField(
                    maxLines: null,
                    maxLength: 200,
                    controller: _commentEntered,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2.0),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey[300], width: 5.0),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        filled: true,
                        isDense: true,
                        contentPadding: EdgeInsets.all(20),
                        hintStyle:
                            TextStyle(color: Colors.grey[800], fontSize: 12),
                        labelText: "Add Comment",
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        alignLabelWithHint: true,
                        fillColor: Colors.grey[300]),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _commentSpinner
                  ? CircularProgressIndicator(color: Colors.yellow[800])
                  : GestureDetector(
                      onTap: () async {
                        setState(() {
                          _commentSpinner = true;
                        });
                        comments.insert(
                            0,
                            Comment(
                                name: readerName,
                                email: readerEmail,
                                comment: _commentEntered.text));
                        await FirebaseFirestore.instance
                            .collection("blog")
                            .doc(widget.blogID)
                            .collection("comments")
                            .add({
                          "name": readerName,
                          "email": readerEmail,
                          "comment": _commentEntered.text,
                        });
                        UsefulMethods()
                            .showToastLong("Your comment has been added.");
                        setState(() {
                          _commentSpinner = false;
                          _commentEntered.text="";
                        });
                      },
                      child: ClassicButtonContainer(
                          text: "Add Comment", color: Colors.yellow[800])),
              ListView.builder(
                shrinkWrap: true,
                itemCount: comments.length,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  var comment = comments[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Container(
                      height: 170,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 35,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    AssetImage("assets/images/userIcon.png")),
                            Flexible(child: SizedBox(width: 20)),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.orange[400],
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Flexible(child: SizedBox(height: 5)),
                                  Text(comment.comment,
                                      style: TextStyle(fontSize: 10)),
                                  Flexible(child: SizedBox(height: 5)),
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
              SizedBox(height: 20),
            ]),
          ],
        ),
      ),
    );
  }
}
