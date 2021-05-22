import 'dart:core';

class Blog {
  final String title;
  final String content;
  final String author;
  final String pic1;
  final String pic2;
  final String blogUID;
  final int views;

  Blog(
      {this.title,
        this.content,
        this.pic1,
        this.pic2,
        this.author,
        this.blogUID,
        this.views});
}