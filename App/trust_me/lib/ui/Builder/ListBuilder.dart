import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trust_me/util/AccountHandle.dart';
import 'package:trust_me/ui/Page/WebSign.dart';
import 'package:trust_me/util/AgreementHandle.dart';
import 'dart:convert';

class AgreementCards extends StatelessWidget {
  // default constructor
  AgreementCards({this.theIcon, this.theText, this.agreement, this.envelopeID});

  // init variables
  final IconData theIcon;
  final String theText;
  final String agreement;
  final String envelopeID;

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
              subtitle: Text(agreement),
            ),
            new ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: const Text('Satisfyed'),
                    onPressed: () {
                      satisfied(envelopeID);
                    },
                  ),
                  new FlatButton(
                    child: const Text('Unsatisfyed'),
                    onPressed: () {
                      unsatisfied(envelopeID);
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

  satisfied(envelopeId) {
    debugPrint("J$envelopeId");
    http.put("http://la6.scottz.net:8080/putState", headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "envelopeId": envelopeId,
      "status": "satisfied"
    }).then((response) {
      debugPrint(response.body.toString());
    });
  }

  unsatisfied(envelopeId) {
    http.put("http://la6.scottz.net:8080/putState", headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "envelopeId": envelopeId,
      "status": "unsatisfied"
    }).then((response) {
      debugPrint(response.body.toString());
    });
  }
}

class SigCards extends StatelessWidget {
  // default constructor
  SigCards(
      {this.theIcon, this.theText, this.agreement, this.envelopeId, this.receiver});

  // init variables
  final IconData theIcon;
  final String theText;
  final String agreement;
  final String envelopeId;
  final String receiver;

  fetchAgreements(agreement, envID, context) async {
    debugPrint(envID);
    debugPrint(agreement);
    http.post("http://la6.scottz.net:8080/generateAgreements", headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "x-access-token": getUserToken()
    }, body: {
      "receiver": getAccountName(),
      "agreement": agreement,
      "envelopeId": envID
    }).then((response) {
      debugPrint("Response get");
//      debugPrint(response.body.toString());
      var agreeList = json.decode(response.body);
//      debugPrint(agreeList.toString());
      var sigURL = agreeList['signingUrl'];
      debugPrint(sigURL);
      setWeb(sigURL, envID);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => WebSign()));
    });
  }

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
              subtitle: Text(agreement),
            ),
            new ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: const Text('Sign'),
                    onPressed: () {
                      debugPrint("call");
                      debugPrint(agreement);
                      debugPrint(envelopeId);
                      fetchAgreements(agreement, envelopeId, context);
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
