import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trust_me/util/AccountHandle.dart';
import 'Drawer.dart';
import 'package:trust_me/ui/WebSign.dart';


class Signature extends StatefulWidget {
  @override
  _SignatureState createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  _SignatureState() {
    fetchEnvolopes();
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
          return agreementCanvas;
        }));
  }

  Widget contentBuilder() {
    if (bGetLeng() == 0) {
      return Center(
        child: Text(
          "No agreements to display",
          style: TextStyle(fontSize: 25.0),
        ),
      );
    } else {
      List<Widget> cardList = [];
      for (int i = 0; i < bGetLeng(); i++) {
        debugPrint("In loop $i");
        var bMap = bEntryExtract(i);
        cardList.add(
          new myCardLayout(
            theIcon: Icons.brightness_1,
            theText: bEntryExtract(i)['sender'],
            aggr: bEntryExtract(i)['agreement'],
            envelopeId: bEntryExtract(i)['envolopes'],
            receiver: bEntryExtract(i)['receiver']
          ),
        );
      }
      debugPrint("In ContentBuilder${cardList.length}");
      return ListView(children: cardList);
    }
  }

  fetchEnvolopes() async {
    debugPrint("Getting envolopes");
    http.get("http://la6.scottz.net:8080/getAgreements", headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "x-access-token": getToken()
    }).then((response) {
      var dataLs = json.decode(response.body);
      debugPrint(dataLs.toString());
      for(int i = 0; i < dataLs.length; i++) {
        debugPrint("1");
        debugPrint(dataLs[i].toString());
        debugPrint('2');
        if(dataLs[i]['state'] == 'pending') {
          bUpdateEntry(
              dataLs[i]['sender'], dataLs[i]['receive'], dataLs[i]['agreement'],
              dataLs[i]['envelopeId']);
          debugPrint('3');
        }
      }
      setState(() {
        agreementCanvas = contentBuilder();
      });
    });
  }
}

class myCardLayout extends StatelessWidget {
  // default constructor
  myCardLayout({this.theIcon, this.theText, this.aggr, this.envelopeId, this.receiver});

  // init variables
  final IconData theIcon;
  final String theText;
  final String aggr;
  final String envelopeId;
  final String receiver;


  fetchAgreements(agreement, envID, context) async {
    debugPrint(envID);
    debugPrint(agreement);
    http.post("http://la6.scottz.net:8080/generateAgreements",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "x-access-token": getToken()
        },
        body: {
          "receiver": getAccountName(),
          "agreement": agreement,
          "envelopeId": envID
        }).then((response) {
          debugPrint("Response get");
//      debugPrint(response.body.toString());
      var aggrList = json.decode(response.body);
//      debugPrint(aggrList.toString());
      var sigURL = aggrList['signingUrl'];
    debugPrint(sigURL);
    setWeb(sigURL, envID);
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => WebSign()));
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
              subtitle: Text(aggr),
            ),
            new ButtonTheme.bar(
              // make buttons use the appropriate styles for cards
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: const Text('Sign'),
                    onPressed: () {
                      debugPrint("call");
                      debugPrint(aggr);
                      debugPrint(envelopeId);
                      fetchAgreements(aggr, envelopeId, context);
//                      getURL(i);
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
