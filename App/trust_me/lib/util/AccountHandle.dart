String token;
bool auth = false;

void updateToken(newToken) {
  token = newToken;
}

String getToken() => token;

void updateAuth(newAuthStatus) {
  auth = newAuthStatus;
}

bool getAuth() => auth;