import 'package:flutter/material.dart';
import 'package:trust_me/ui/Account.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TrustMe',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Login()
    );
  }
}