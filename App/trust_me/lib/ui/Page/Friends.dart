import 'package:flutter/material.dart';

import 'package:trust_me/ui/Builder/Drawer.dart';

class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Friends"),
        ),
        drawer: getDrawer(context),
        body: ListView(
          children: <Widget>[
            generateListTile("Friend1", "friend1@email.com"),
            generateListTile("Friend2", "friend2@email.com"),
          ],
        ));
  }

  generateListTile(friendName, email) {
    return FlatButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => friendName(Icons.person_outline, friendName))),
        child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
                padding: EdgeInsets.only(right: 12.0),
                decoration: new BoxDecoration(
                    border: new Border(
                        right:
                            new BorderSide(width: 1.0, color: Colors.black))),
                child: Stack(
                  alignment: FractionalOffset.center,
                  children: <Widget>[
                    Icon(
                      Icons.brightness_1,
                      color: Color(0xA041b3a3),
                      size: 70.0,
                    ),
                    Text(
                      friendName[0],
                      style: TextStyle(fontSize: 30.0, color: Colors.white),
                    )
                  ],
                )),
            title: Text(
              friendName,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

            subtitle: Row(
              children: <Widget>[
                Icon(Icons.email, color: Colors.black),
                Padding(padding: EdgeInsets.all(2.0)),
                Text(email, style: TextStyle(color: Colors.black))
              ],
            ),
            trailing: Icon(Icons.keyboard_arrow_right,
                color: Colors.black, size: 30.0)));
  }
}

class FriendsInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.purple,
        title: new Text("Flutter Card Example"),
      ), // appBar
      body: new Container(
        padding: new EdgeInsets.all(10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new myCardLayout(theIcon: Icons.headset, theText: "Headset"),
            new myCardLayout(theIcon: Icons.mic, theText: "Mic"),
            new myCardLayout(theIcon: Icons.speaker, theText: "Speaker"),
            //this is not the list example, so when you add new cards, it won't be inside of the list.
          ],
        ), // column
      ), // Container
    ); // scaffold
  }
}

class myCardLayout extends StatelessWidget {
  // default constructor
  myCardLayout({this.theIcon, this.theText});

  // init variables
  final IconData theIcon;
  final String theText;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              leading: new Icon(theIcon, size: 40.0, color: Colors.grey),
              title: new Text(
                theText,
                style: new TextStyle(fontSize: 20.0),
              ),
              subtitle:
                  const Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
            ),
            new ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: const Text('BUY TICKETS'),
                    onPressed: () {
                      /* ... */
                    },
                  ),
                  new FlatButton(
                    child: const Text('LISTEN'),
                    onPressed: () {
                      /* ... */
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
