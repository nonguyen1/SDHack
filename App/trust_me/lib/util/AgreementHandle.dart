import 'package:flutter/material.dart';

// Sender
List<String> _aEnvelopeIDs = [];
List<String> _aAgreements = [];
List<String> _aReceivers = [];
// Receiver
List<String> _bEnvelopeIDs = [];
List<String> _bAgreements = [];
List<String> _bSender = [];
List<String> _bReceiver = [];

// For use in Web View
String _webLink = '';
String _envID = '';

void setWeb(webLink, envLink) {
  _webLink = webLink;
  _envID = envLink;
}

String getWeb() => _webLink;

String getEnvelopeID() => _envID;


void aNewEntry(envelopeID, agreement, receiver) {
  // Append input envelope to envelope list if it's not already in
  if (!_aEnvelopeIDs.contains(envelopeID)) {
    _aEnvelopeIDs.add(envelopeID);
    _aAgreements.add(agreement);
    _aReceivers.add(receiver);
  }
}

void bNewEntry(sender, receiver, agreement, envelope) {
  // Append input envelope to envelope list if it's not already in
  if (!_bEnvelopeIDs.contains(envelope)) {
    _bSender.add(sender);
    _bReceiver.add(receiver);
    _bAgreements.add(agreement);
    _bEnvelopeIDs.add(envelope);
  }
}

aGetEntry(index) {
  if (index < _aEnvelopeIDs.length) {
    return {
      'envelope': _aEnvelopeIDs[index],
      'agreement': _aAgreements[index],
      'receiver': _aReceivers[index]
    };
  } else {
    debugPrint("Array index out of bound in getEntry$index");
  }
}

bGetEntry(index) {
  if (index < _bEnvelopeIDs.length) {
    return {
      'sender': _bSender[index],
      'receiver': _bReceiver[index],
      'agreement': _bAgreements[index],
      'envolopes': _bEnvelopeIDs[index]
    };
  } else {
    debugPrint("Array index out of bound in bGetEntry$index");
  }
}

aGetLength() => _aAgreements.length;

bGetLength() => _bSender.length;

void clearBufferedAgreements() {
  _aEnvelopeIDs = [];
  _aAgreements = [];
  _aReceivers = [];
  _webLink = '';
  _bSender = [];
  _bReceiver = [];
  _bAgreements = [];
  _bEnvelopeIDs = [];
}
