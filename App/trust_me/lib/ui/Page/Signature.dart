import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trust_me/util/AccountHandle.dart';
import 'package:trust_me/ui/Builder/Drawer.dart';
import 'package:trust_me/util/AgreementHandle.dart';
import 'package:trust_me/ui/Builder/ListBuilder.dart';

class Signature extends StatefulWidget {
  @override
  _SignatureState createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  _SignatureState() {
    fetchEnvelopes();
  }

  Widget agreementCanvas = Center(
    child: Text(
      "Please wait ...",
      style: TextStyle(fontSize: 20.0),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Pending Signature")),
        drawer: getDrawer(context),
        body: Builder(builder: (context) {
          return agreementCanvas;
        }));
  }

  Widget contentBuilder() {
    if (bGetLength() == 0) {
      return Center(
          child: Text(
        "No agreements to display",
        style: TextStyle(fontSize: 25.0),
      ));
    } else {
      List<Widget> cardList = [];
      for (int i = 0; i < bGetLength(); i++) {
        var currentEntry = bGetEntry(i);
        cardList.add(
          new SigCards(
              theIcon: Icons.brightness_1,
              theText: currentEntry['sender'],
              agreement: currentEntry['agreement'],
              envelopeId: currentEntry['envolopes'],
              receiver: currentEntry['receiver']),
        );
      }
      return ListView(children: cardList);
    }
  }

  fetchEnvelopes() async {
    debugPrint("Getting envolopes");
    http.get("http://la6.scottz.net:8080/getAgreements", headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "x-access-token": getUserToken()
    }).then((response) {
      var pendingList = json.decode(response.body);
      for (int i = 0; i < pendingList.length; i++) {
        if (pendingList[i]['state'] == 'pending') { // Filter out other unwanted types
          bNewEntry(pendingList[i]['sender'], pendingList[i]['receive'],
              pendingList[i]['agreement'], pendingList[i]['envelopeId']);
        }
      }
      setState(() {
        agreementCanvas = contentBuilder();
      });
    });
  }
}
