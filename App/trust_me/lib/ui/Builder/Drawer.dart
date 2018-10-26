import 'package:flutter/material.dart';
import 'package:trust_me/ui/Page/Account.dart';
import 'package:trust_me/ui/Page/Agreements.dart';
import 'package:trust_me/ui/Page/Friends.dart';
import 'package:trust_me/ui/Page/Sign.dart';
import 'package:trust_me/ui/Page/WebSign.dart';
import 'package:trust_me/util/AccountHandle.dart';
import 'package:trust_me/ui/Page/Signature.dart';
import 'package:trust_me/util/AgreementHandle.dart';

getDrawer(currentBuildContext) => new Drawer(
        child: ListView(
//      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 150.0,
          child: new UserAccountsDrawerHeader(
            accountName: new Text(
              getAccountName(),
              style: TextStyle(fontSize: 20.0),
            ),
            accountEmail: null,
            currentAccountPicture: Stack(
              alignment: FractionalOffset.center,
              children: <Widget>[
                Icon(
                  Icons.brightness_1,
                  color: Color(0xA041b3a3),
                  size: 70.0,
                ),
                Text(
                  getAccountName()[0],
                  style: TextStyle(fontSize: 30.0, color: Colors.white),
                )
              ],
            ),
          ),
        ),
        ListTile(
          title: Row(children: <Widget>[
            Icon(Icons.vpn_key),
            Padding(padding: EdgeInsets.all(10.0)),
            Text("Sign")
          ]),
          onTap: () => Navigator.pushReplacement(currentBuildContext,
              MaterialPageRoute(builder: (context) => Sign())),
        ),
//        ListTile(
//          title: Row(children: <Widget>[
//            Icon(Icons.people),
//            Padding(padding: EdgeInsets.all(10.0)),
//            Text("Friends")
//          ]),
//          onTap: () => Navigator.pushReplacement(currentBuildContext,
//              MaterialPageRoute(builder: (context) => Friends())),
//        ),
        ListTile(
          title: Row(children: <Widget>[
            Icon(Icons.check),
            Padding(padding: EdgeInsets.all(10.0)),
            Text("Agreements")
          ]),
          onTap: () => Navigator.pushReplacement(currentBuildContext,
              MaterialPageRoute(builder: (context) => Agreements())),
        ),
        ListTile(
          title: Row(children: <Widget>[
            Icon(Icons.check),
            Padding(padding: EdgeInsets.all(10.0)),
            Text("Pending Signature")
          ]),
          onTap: () => Navigator.pushReplacement(currentBuildContext,
              MaterialPageRoute(builder: (context) => Signature())),
        ),
//        ListTile(
//          title: Row(children: <Widget>[
//            Icon(Icons.web_asset),
//            Padding(padding: EdgeInsets.all(10.0)),
//            Text("WebSign")
//          ]),
//          onTap: () => Navigator.pushReplacement(currentBuildContext,
//              MaterialPageRoute(builder: (context) => WebSign())),
////            MaterialPageRoute(builder: (context) => null)),
//        ),
        ListTile(
          title: Row(children: <Widget>[
            Icon(Icons.do_not_disturb_alt),
            Padding(padding: EdgeInsets.all(10.0)),
            Text("Sign Out")
          ]),
          onTap: () {
            clearBufferedAgreements();
            Navigator.pushReplacement(currentBuildContext,MaterialPageRoute(builder: (context) => Login()));
          },
//            MaterialPageRoute(builder: (context) => null)),
        ),
      ],
    ));
