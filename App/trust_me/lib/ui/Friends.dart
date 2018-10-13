import 'package:flutter/material.dart';
import 'Drawer.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Friends")),
        drawer: getDrawer(context),
        body: ListView(

        ));
  }
}
