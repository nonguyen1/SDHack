import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trust_me/util/AccountHandle.dart';

import 'Drawer.dart';

class Agreements extends StatefulWidget {
  @override
  _AgreementsState createState() => _AgreementsState();
}

class _AgreementsState extends State<Agreements> {
  _AgreementsState() {
    fetchAgreements();
  }

  Widget agreementCanvas = Center(
    child: Text(
      "Waiting for response",
      style: TextStyle(fontSize: 20.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Agreement")),
        drawer: getDrawer(context),
        body: Builder(builder: (context) {
//          fetchAgreements();
          return agreementCanvas;
        }));
  }

  Widget contentBuilder() {
//    debugPrint(getAgreementLength().toString());
    if (getAgreementLength() == 0) {
      return Center(
        child: Text(
          "No agreements to display",
          style: TextStyle(fontSize: 25.0),
        ),
      );
    } else {
      List<Widget> cardList = [];
      for (int i = 0; i < getAgreementLength(); i++) {
        debugPrint("In loop $i");
        cardList.add(
          new myCardLayout(
            theIcon: Icons.brightness_1,
            theText: getEntry(i)['receiver'],
            aggr: getEntry(i)['agreement'],
            envelopeId: getEntry(i)['envelope'],
          ),
        );
      }
      debugPrint("In ContentBuilder${cardList.length}");
      return ListView(children: cardList);
    }
  }

  fetchAgreements() async {
    http.get("https://trustme-219322.appspot.com/getAgreements", headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "x-access-token": getToken()
    }).then((response) {
      debugPrint(response.body.toString());
      var aggrList = json.decode(response.body);
      for (int i = 0; i < aggrList.length; i++) {
        newEntry(aggrList[i]['envelopeId'], aggrList[i]['agreement'],
            aggrList[i]['receiver']);
//        debugPrint(aggrList[i]['envelopeId']);
      }
      setState(() {
        agreementCanvas = contentBuilder();
      });
    });
  }

  fetchURL(envID, agree) async {
    http.post("https://trustme-219322.appspot.com/generateAgreements",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "x-access-token": getToken()
        },
        body: {
          "receiver": getAccountName(),
          "agreement": agree,
          "envelopeId": envID
        }).then((response) {
      var dec = json.decode(response.body);
      debugPrint(dec['signingUrl']);
      return dec['signingUrl'];
    });
  }
}

class myCardLayout extends StatelessWidget {
  // default constructor
  myCardLayout({this.theIcon, this.theText, this.aggr, this.envelopeId});

  // init variables
  final IconData theIcon;
  final String theText;
  final String aggr;
  final String envelopeId;

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
              subtitle: Text(aggr),
            ),
            new ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: const Text('Satisfyed'),
                    onPressed: () {
                      satisfied(envelopeId);
                    },
                  ),
                  new FlatButton(
                    child: const Text('Unsatisfyed'),
                    onPressed: () {
                      unsatisfied(envelopeId);
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
    http.put("https://trustme-219322.appspot.com/putState", headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "envelopeId": envelopeId,
      "status": "satisfied"
    }).then((response) {
      debugPrint(response.body.toString());
    });
  }

  unsatisfied(envelopeId) {
    http.put("https://trustme-219322.appspot.com/putState", headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "envelopeId": envelopeId,
      "status": "unsatisfied"
    }).then((response) {
      debugPrint(response.body.toString());
    });
  }
}
