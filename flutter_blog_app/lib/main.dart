import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'Authentication.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';

void main()
{
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode)
      exit(1);
  };

  runApp(new BlogApp());
}

class BlogApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Blog App",
      debugShowCheckedModeBanner: false,


      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),

      home: MappingPage(auth: Auth(),),

    );
  }
}