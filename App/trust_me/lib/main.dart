import 'package:flutter/material.dart';
import 'package:trust_me/ui/Page/Account.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TrustMe',
      theme: new ThemeData(
          fontFamily: 'Product Sans',
//        primarySwatch: Colors.blueGrey,
//        backgroundColor: Colors.blueGrey,
//        scaffoldBackgroundColor: Colors.blueGrey,
//        cardColor: Colors.blueGrey,
        brightness: Brightness.dark,
        accentColor: Colors.white,
//        primaryColor: Color(0xFF),
      ),
      home: new Login()
    );
  }
}