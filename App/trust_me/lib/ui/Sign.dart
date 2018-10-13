import 'package:flutter/material.dart';
import 'Drawer.dart';

class Sign extends StatefulWidget {
  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sign")),
        drawer: getDrawer(context),
        body: ListView(

        ));
  }
}
