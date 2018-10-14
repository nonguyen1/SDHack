import 'package:flutter/material.dart';

String _token;
bool _auth = false;
String _accountName = '';
List<String> _envelopeIDs = [];
List<String> _agreements = [];
List<String> _receivers = [];
String _webLink = '';

void updateToken(newToken) {
  _token = newToken;
}

String getToken() => _token;

void updateAuth(newAuthStatus) {
  _auth = newAuthStatus;
}

bool getAuth() => _auth;

void updateAccountName(newAccountName) {
  _accountName = newAccountName;
}

String getAccountName() => _accountName;

void newEntry(envelopeID, agreement, receiver) {
  // Append input envolope to envolope list if it's not already in
  for (int i = 0; i < _envelopeIDs.length; i++) {
    if (_envelopeIDs[i] == envelopeID) return;
  }
  _envelopeIDs.add(envelopeID);
  _agreements.add(agreement);
  _receivers.add(receiver);
}

getEntry(ii) {
  if (ii < _envelopeIDs.length) {
    return {'envelope':_envelopeIDs[ii], 'agreement': _agreements[ii], 'receiver': _receivers[ii]};
  }
  else {
    debugPrint("Array index out of bound in getEntry$ii");
  }
}
getAgreementLength() => _agreements.length;

void setWeb(webLink) {
  _webLink = webLink;
}

String getWeb() => _webLink;

clearStuff() {
  _token = '';
  _auth = false;
   _accountName = '';
  _envelopeIDs = [];
  _agreements = [];
  _receivers = [];
  _webLink = '';
}