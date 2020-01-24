import 'package:flutter/material.dart';
import 'LoginRegisterPage.dart';
import 'HomePage.dart';

void main()
{
  runApp(new BlogApp());
}

class BlogApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Blog App",
      

      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),

      home: HomePage(),

    );
  }
}