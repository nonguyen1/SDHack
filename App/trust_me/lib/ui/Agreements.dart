import 'package:flutter/material.dart';
import 'Drawer.dart';

class Agreements extends StatefulWidget {
  @override
  _AgreementsState createState() => _AgreementsState();
}

class _AgreementsState extends State<Agreements> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Agreement")),
        drawer: getDrawer(context),
        body: ListView(

        ));
  }
}
