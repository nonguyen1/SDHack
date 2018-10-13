String token;
bool auth = false;
String accountName = '';

void updateToken(newToken) {
  token = newToken;
}

String getToken() => token;

void updateAuth(newAuthStatus) {
  auth = newAuthStatus;
}

bool getAuth() => auth;

void updateAccountName(newAccountName) {
  accountName = newAccountName;
}

String getAccountName() => accountName;
