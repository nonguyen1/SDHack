import 'package:flutter/material.dart';
import 'package:trust_me/util/AccountHandle.dart';
import 'package:trust_me/ui/Sign.dart';
import 'package:trust_me/ui/Friends.dart';
import 'package:trust_me/ui/Agreements.dart';


getDrawer(currentBuildContext) => new Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 150.0,
          child: new UserAccountsDrawerHeader(
              accountName: new Text(getAccountName()), accountEmail: null),
        ),
        ListTile(
          title: Row(children: <Widget>[Icon(Icons.vpn_key),Padding(padding: EdgeInsets.all(10.0)),Text("Sign")]),
          onTap: () => Navigator.pushReplacement(currentBuildContext, MaterialPageRoute(builder: (context) => Sign())),
        ),
        ListTile(
          title: Row(children: <Widget>[Icon(Icons.people),Padding(padding: EdgeInsets.all(10.0)),Text("Friends")]),
          onTap: () => Navigator.pushReplacement(currentBuildContext, MaterialPageRoute(builder: (context) => Friends())),
        ),
        ListTile(
          title: Row(children: <Widget>[Icon(Icons.check),Padding(padding: EdgeInsets.all(10.0)),Text("Agreements")]),
          onTap: () => Navigator.pushReplacement(currentBuildContext, MaterialPageRoute(builder: (context) => Agreements())),
        ),
      ],
    ));
