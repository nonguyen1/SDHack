import 'package:flutter/material.dart';

getDrawer() => new Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 150.0,
          child: new UserAccountsDrawerHeader(
              accountName: new Text("User Name"), accountEmail: null),
        ),
        ListTile(
          title: Text("Sign"),
          onTap: () => debugPrint("sign!"),
        ),
        ListTile(
          title: Text("Friends"),
          onTap: () => debugPrint("Friends!"),
        ),
        ListTile(
          title: Text("Agreements"),
          onTap: () => debugPrint("Agreements!"),
        ),
      ],
    ));
