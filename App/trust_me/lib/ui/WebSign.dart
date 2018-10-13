import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trust_me/ui/Drawer.dart';

class WebSign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: getDrawer(context),
      body: new Center(
        child: new RaisedButton(
          onPressed: _launchURL,
          child: new Text('Sign it!'),
        ),
      ),
    );
  }

  _launchURL() async {
    debugPrint("Hi");
    const url = 'https://google.com';
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }
}
