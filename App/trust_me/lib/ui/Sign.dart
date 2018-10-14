import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trust_me/util/AccountHandle.dart';

import 'Drawer.dart';

class Sign extends StatefulWidget {
  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  bool signed = false;
  final MUST_SIGN_SB = SnackBar(content: Text('Please sign the agreement'));
  final CHECK_INPUT_SN = SnackBar(
      content: Text('You have to fill the recipient email and content'));
  final SENDING_SB = SnackBar(content: Text('Sending agreement to docusign'));
  final SENT_SB = SnackBar(content: Text('Sent'));
  final TextEditingController _recipientController =
      new TextEditingController();
  final TextEditingController _descriptionController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign"),
        ),
        drawer: getDrawer(context),
        body: Builder(
            builder: (context) => ListView(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.all(30.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person,
                          size: 120.0,
                        ),
                        Column(
                          children: <Widget>[
                            Icon(Icons.chevron_right, size: 100.0)
                          ],
                        ),
                        Icon(
                          Icons.person,
                          size: 120.0,
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.all(15.0)),
                    Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(5.0)),
                        Text(
                          "Agreement with:",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w500),
                        ),
                        Padding(padding: EdgeInsets.all(5.0)),
                        Flexible(
                          child: TextField(
                            controller: _recipientController,
                            decoration:
                                InputDecoration(hintText: "Recepient Email"),
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5.0))
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    Padding(padding: EdgeInsets.all(20.0)),
                    Row(
                      children: <Widget>[
                        Padding(padding: EdgeInsets.all(10.0)),
                        Flexible(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            controller: _descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              hintText: "Contract content",
                            ),
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.black),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(10.0)),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: signed,
                            onChanged: (bool val) {
                              setState(() {
                                signed = val;
                              });
                            }),
                        Flexible(
                          child: Text("Sign the agreement"),
                        ),
                        Padding(padding: EdgeInsets.all(10.0)),
                        Expanded(
                            child: Row(
                          children: <Widget>[
                            Flexible(child: Text("Time")),
                            Padding(padding: EdgeInsets.all(5.0))
                          ],
                          mainAxisAlignment: MainAxisAlignment.end,
                        ))
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
//            Expanded(
//                child: Column(
//              children: <Widget>[],
//              mainAxisAlignment: MainAxisAlignment.end,
//            )),
                    Padding(padding: EdgeInsets.all(20.0)),
                    // TODO: Fix the button placement issue
                    RaisedButton(
                      onPressed: () => signed
                          ? docuSign(context)
                          : Scaffold.of(context).showSnackBar(MUST_SIGN_SB),
                      child: Text(
                        "Docusign!!",
                      ),
                    ),
                  ],
                )));
  }

  docuSign(context) {
    if (_recipientController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(CHECK_INPUT_SN);
      return;
    } else {
      Scaffold.of(context).showSnackBar(SENDING_SB);
      var url = "http://la6.scottz.net:3000/createAgreements";
      debugPrint('Trying to send, my token is ${getToken()}');
      http.post(url, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "x-access-token": getToken()
      }, body: {
        "receiver": _recipientController.text,
        "agreement": _descriptionController.text
      }).then((response) {
        if (response.statusCode == 200) {
          Map userMap = json.decode(response.body);
          debugPrint(userMap.toString());
          if (userMap['sender'] == getAccountName() &&
              userMap['receiver'] == _recipientController.text &&
              userMap['agreement'] == _descriptionController.text) {
            Scaffold.of(context).showSnackBar(SENT_SB);
          }
        } else {
          debugPrint(
              "Error. Response Code is ${response.statusCode} body is ${response.body}");
        }
        Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                'Error. Response Code is ${response.statusCode} body is ${response.body}')));
      });
    }
  }
}
