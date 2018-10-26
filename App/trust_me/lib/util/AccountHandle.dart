import 'package:flutter/material.dart';

String _token;
bool _auth = false;
String _accountName = '';
String _displayAgreementType = 'signed';

void updateToken(newToken) {
  _token = newToken;
}

String getUserToken() => _token;

void updateAuth(newAuthStatus) {
  _auth = newAuthStatus;
}

bool getAuth() => _auth;

void updateAccountName(newAccountName) {
  _accountName = newAccountName;
}

String getAccountName() => _accountName;

void setDisplayAgreementType(String agreementType) {
  _displayAgreementType = agreementType;
}

getDisplayAgreementType() => _displayAgreementType != 'null'? _displayAgreementType : null; // null for debugging
String getDisplayAgreementTypeCap() => _displayAgreementType[0].toUpperCase() + _displayAgreementType.substring(1);