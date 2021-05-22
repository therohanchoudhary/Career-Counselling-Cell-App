import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnc_app/blog/AddBlog.dart';
import 'package:cnc_app/starting_screens/IntroScreen.dart';
import 'package:cnc_app/utility/BlogClass.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'blog/SingleArticleScreen.dart';

class UserHomeScreen extends StatefulWidget {
  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  String name = '';
  var firestoreInstance = FirebaseFirestore.instance;
  bool _blogsLoading = false;

  final List<Blog> blogs = <Blog>[];

  getBlogs() async {
    setState(() {
      _blogsLoading = true;
    });

    firestoreInstance.collection("blog").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        var blog = result.data();
        if (blog["accept"] != 0) {
          print('"1000000');
          blogs.add(
            Blog(
              title: blog["title"],
              content: blog["content"],
              author: blog["author"],
              pic1: blog["pic1"],
              pic2: blog["pic2"],
              views: blog["views"],
              blogUID: blog["blogUID"],
            ),
          );
          if (mounted) {
            setState(() {});
          }
        }
      });
    });

    setState(() {
      _blogsLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: SafeArea(
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                  height: 70,
                  child: DrawerHeader(
                    child:
                        Text('C&C App', style: TextStyle(color: Colors.white)),
                    decoration: BoxDecoration(color: Colors.yellow[700]),
                  ),
                ),
                ListTile(
                  title: Text("Add Blog"),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddBlogScreen()));
                  },
                ),
                ListTile(
                  title: Text("Logout"),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => IntroScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
            title: Text('Welcome $name'), backgroundColor: Colors.yellow[700]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _blogsLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: blogs.length,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        var blog = blogs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SingleArticleScreen(
                                          title: blog.title,
                                          author: blog.author,
                                          content: blog.content,
                                          pic1: blog.pic1,
                                          pic2: blog.pic2,
                                          views: blog.views,
                                          blogID: blog.blogUID,
                                        )));
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            child: Container(
                              height: 170,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 8),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 50,
                                        backgroundImage: blog.pic1 != null
                                            ? NetworkImage(blog.pic1)
                                            : AssetImage(
                                                "assets/images/career.jpeg")),
                                    SizedBox(width: 20),
                                    Flexible(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            blog.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.orange[800],
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Flexible(child: SizedBox(height: 5)),
                                          Text(blog.author),
                                          Flexible(child: SizedBox(height: 5)),
                                          Text(
                                            blog.content,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
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
                          ),
                        );
                      },
                    ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
