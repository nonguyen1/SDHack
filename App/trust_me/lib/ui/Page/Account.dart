import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trust_me/ui/Page/Sign.dart';
import 'package:trust_me/util/AccountHandle.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userNameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  BuildContext _scaffoldContext;

  @override
  Widget build(BuildContext context) => Scaffold(
//      drawer: getDrawer(),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Trust Me"),
      ),
      body: Builder(builder: (context) {
        _scaffoldContext = context;
        return Stack(
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("assets/background_crop.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: ListView(
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(20.0)),
                  // Login text
                  Center(
//              child: Text(
//                'Login',
//                style: TextStyle(fontSize: 50.0),
//              ),
//                    child: Image.asset('assets/face.png'),
                      child: Container(
                    child: Image.asset('assets/logo.png'),
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment(0.0, -0.3),
                  )),
//                  Padding(padding: EdgeInsets.all(10.0)),
                  // Username text box
                  Row(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.all(10.0)),
                      Flexible(
                        child: TextField(
                          controller: _userNameController,
                          decoration: InputDecoration(
                            hintText: "Username",
                            icon: Icon(Icons.person),
                          ),
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
                  Padding(
                    padding: EdgeInsets.all(5.0),
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
          ],
        );
      }));

  createAccount() {
    if (_userNameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var url = "http://la6.scottz.net:8080/users";
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
            debugPrint('Successfully Registered. Please log in.');
            Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
                content: Text('Successfully Registered. Please log in.')));
            updateToken(userMap['token']);
            updateAuth(true);
          } else {
            debugPrint('Registration failed. $userMap');
            Scaffold.of(_scaffoldContext).showSnackBar(
                SnackBar(content: Text('Registration failed. $userMap')));
          }
        } else {
          debugPrint(
              'Registration Error. Response Code is ${response.statusCode} body is ${response.body}');
          Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
              content: Text(
                  'Registration Error. Response Code is ${response.statusCode} body is ${response.body}')));
          debugPrint(
              "Registration Failed. Response Code is ${response.statusCode} body is ${response.body}");
        }
      });
    }
  }

  loginAccount() {
    if (_userNameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      var url = "http://la6.scottz.net:8080/loginUser";
      http.post(url, headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      }, body: {
        "mail": _userNameController.text,
        "passwd": _passwordController.text
      }).then((response) {
        debugPrint(response.body.toString());
        if (response.statusCode == 201) {
          Map userMap = json.decode(response.body);
          debugPrint(userMap.toString());
          if (userMap['auth']) {
            Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
                content: Text('Welcome back ${_userNameController.text}')));
            debugPrint('Authenticated');
            updateToken(userMap['token']);
            updateAuth(true);
            updateAccountName(_userNameController.text);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Sign()));
          } else {
            debugPrint('Authentication failed. $userMap');
            Scaffold.of(_scaffoldContext).showSnackBar(
                SnackBar(content: Text('Authentication failed. $userMap')));
          }
        } else {
          Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
              content: Text(
                  'Login Error. Response Code is ${response.statusCode} body is ${response.body}')));
          debugPrint(
              "Login Error. Response Code is ${response.statusCode} body is ${response.body}");
        }
      });
    }
  }
}
