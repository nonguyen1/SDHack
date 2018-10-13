import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trust_me/util/AccountHandle.dart';
import 'package:trust_me/ui/Sign.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userNameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      drawer: getDrawer(),
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(20.0)),
            // Login text
            Center(
//              child: Text(
//                'Login',
//                style: TextStyle(fontSize: 50.0),
//              ),
            child: Image.asset('assets/face.png'),
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            // Username text box
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10.0)),
                Flexible(
                  child: TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                        hintText: 'Username', icon: Icon(Icons.person)),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10.0)),
              ],
            ),
            Padding(padding: EdgeInsets.all(10.0)),
            // Password text box
            Row(
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10.0)),
                Flexible(
                    child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      hintText: 'Password', icon: Icon(Icons.lock)),
                )),
                Padding(padding: EdgeInsets.all(10.0)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                    onPressed: loginAccount,
                    child: Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    )),
                Padding(padding: EdgeInsets.all(50.0)),
                RaisedButton(
                    onPressed: createAccount,
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w500),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  createAccount() {
    if (_userNameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var url = "http://la6.scottz.net:3000/users";
      http.post(url, headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      }, body: {
        "mail": _userNameController.text,
        "passwd": _passwordController.text
      }).then((response) {
        if (response.statusCode == 201) {
          Map userMap = json.decode(response.body);
          debugPrint(userMap.toString());
          if (userMap['auth']) {
            debugPrint('Registered');
            updateToken(userMap['token']);
            updateAuth(true);
          } else {
            print('Registration failed. $userMap');
          }
        } else {
          // TODO: Print this on screen
          debugPrint(
              "Login Error. Response Code is ${response.statusCode} body is ${response.body}");
        }
      });
    }
  }

  loginAccount() {
    if (_userNameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var url = "http://la6.scottz.net:3000/loginUser";
      http.post(url, headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      }, body: {
        "mail": _userNameController.text,
        "passwd": _passwordController.text
      }).then((response) {
        if (response.statusCode == 201) {
          Map userMap = json.decode(response.body);
          debugPrint(userMap.toString());
          if (userMap['auth']) {
            debugPrint('Authenticated');
            updateToken(userMap['token']);
            updateAuth(true);
            updateAccountName(_userNameController.text);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Sign()));
          } else {
            print('Authentication failed. $userMap');
          }
        } else {
          // TODO: Print this on screen
          debugPrint(
              "Login Error. Response Code is ${response.statusCode} body is ${response.body}");
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('hi')));
        }
      });
    }
  }
}
