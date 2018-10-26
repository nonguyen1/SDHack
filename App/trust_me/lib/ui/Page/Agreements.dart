import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trust_me/util/AccountHandle.dart';
import 'package:trust_me/ui/Builder/Drawer.dart';
import 'package:trust_me/util/AgreementHandle.dart';
import 'package:trust_me/ui/Builder/ListBuilder.dart';
import 'package:trust_me/constants.dart';

class Agreements extends StatefulWidget {
  @override
  _AgreementsState createState() => _AgreementsState();
}

class _AgreementsState extends State<Agreements> {
  _AgreementsState() {
    clearBufferedAgreements();
    fetchAgreements();
  }
  var refreshKey = GlobalKey<RefreshIndicatorState>(); // Pull down for refresh

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    clearBufferedAgreements();
    await fetchAgreements();
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
        appBar: AppBar(
          title: Text(getDisplayAgreementTypeCap() + " Agreements"),
          actions: <Widget>[
            PopupMenuButton(
                onSelected: changeDisplayType,
                itemBuilder: (BuildContext context) {
                  return Constants.AGREEMENT_PAGE_CHOICES.map((String choice) {
                    return PopupMenuItem<String>(
                      child: Text(choice),
                      value: choice,
                    );
                  }).toList();
                })
          ],
        ),
        drawer: getDrawer(context),
        body: Builder(builder: (context) {
//          fetchAgreements();
          return agreementCanvas;
        }));
  }

  void changeDisplayType(String choice) {
    setDisplayAgreementType(choice);
    clearBufferedAgreements();
    fetchAgreements();
  }

  Widget contentBuilder() {
    if (aGetLength() == 0) {
      return Center(
        child: Text(
          "No agreements to display",
          style: TextStyle(fontSize: 25.0),
        ),
      );
    } else {
      List<Widget> cardList = [];
      for (int i = 0; i < aGetLength(); i++) {
        var currentEntry = aGetEntry(i);
        cardList.add(
          new AgreementCards(
            theIcon: Icons.brightness_1,
            theText: currentEntry['receiver'],
            agreement: currentEntry['agreement'],
            envelopeID: currentEntry['envelope'],
          ),
        );
      }
//      return ListView(children: cardList);
        return RefreshIndicator(child: ListView(children: cardList,), onRefresh: refreshList, key: refreshKey,);
    }
  }

  fetchAgreements() async {
    // Get agreements, then after received response, agreementCanvas will be updated to contentBuilder, which builds the cards
    http.get("http://la6.scottz.net:8080/getAgreements", headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "x-access-token": getUserToken()
    }).then((response) {
//      debugPrint(response.body.toString());
      var agreementList = json.decode(response.body);
      debugPrint(agreementList.toString());
      for (int i = 0; i < agreementList.length; i++) {
        if (agreementList[i]['state'] == getDisplayAgreementType()) { // Filter out other unwanted types as user request
          aNewEntry(agreementList[i]['envelopeId'],
              agreementList[i]['agreement'], agreementList[i]['receiver']);
        }
      }
      setState(() {
        // Update the page according to responses
        agreementCanvas = contentBuilder();
      });
    });
  }
}
