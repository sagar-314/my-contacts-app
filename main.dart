// import 'package:firebaselogin/SigninPage.dart';
// import 'package:firebaselogin/SignupPage.dart';
import 'package:flutter/material.dart';
import 'Screens/HomePage.dart';

void main() => runApp(MyApp());

// place google json file in android and iOS 
// Gradle for Android
// yaml for flutter

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}

