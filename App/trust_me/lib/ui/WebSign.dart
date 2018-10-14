import 'package:flutter/material.dart';
import 'package:flutter_web_view/flutter_web_view.dart';
import 'package:trust_me/ui/Drawer.dart';
import 'package:trust_me/ui/Sign.dart';
import 'package:trust_me/util/AccountHandle.dart';
import 'package:http/http.dart' as http;


class WebSign extends StatefulWidget {
  @override
  _WebSignState createState() => new _WebSignState();
}

class _WebSignState extends State<WebSign> {
  String _redirectedToUrl;
  FlutterWebView flutterWebView = new FlutterWebView();
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget leading;
    if (_isLoading) {
      leading = new CircularProgressIndicator();
    }
    var columnItems = <Widget>[
      new MaterialButton(
          onPressed: launchWebViewExample, child: new Text("Launch"))
    ];
    if (_redirectedToUrl != null) {
      columnItems.add(new Text("Redirected to $_redirectedToUrl"));
    }
    var app = new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          leading: leading,
        ),
        drawer: getDrawer(context),
        body: new Column(
          children: columnItems,
        ),
      ),
    );

    // Auto launch webview
    launchWebViewExample();
    // ^^^ Auto launch webview
    return app;
  }

  void launchWebViewExample() {
    if (flutterWebView.isLaunched) {
      return;
    }

    flutterWebView.launch(getWeb(),
        headers: {
          "X-SOME-HEADER": "MyCustomHeader",
        },
        javaScriptEnabled: true,
        // Enable this to get docusign web page working
        toolbarActions: [
          new ToolbarAction("Dismiss", 1),
          new ToolbarAction("Reload", 2)
        ],
        barColor: Colors.green,
        tintColor: Colors.white);
    flutterWebView.onToolbarAction.listen((identifier) {
      switch (identifier) {
        case 1:
          flutterWebView.dismiss();
          break;
        case 2:
          reload();
          break;
      }
    });
//    flutterWebView.listenForRedirect("http://localhost:4000/dsreturn?event=viewing_complete", true);
    flutterWebView.listenForRedirect("http://localhost:4000/dsreturn", true);

    flutterWebView.onWebViewDidStartLoading.listen((url) {
      setState(() => _isLoading = true);
    });
    flutterWebView.onWebViewDidLoad.listen((url) {
      setState(() => _isLoading = false);
    });
    flutterWebView.onRedirect.listen((url) {
      debugPrint(url);
      if (url == "http://localhost:4000/dsreturn?event=viewing_complete") {
        debugPrint("Viewing complete");
      } else if (url ==
          "http://localhost:4000/dsreturn?event=signing_complete") {
        signComplete();
      }
      flutterWebView.dismiss();
      setState(() => _redirectedToUrl = url);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Sign()));
    });
  }

  void reload() {
    flutterWebView.load(
      getWeb(),
      headers: {
        "X-SOME-HEADER": "MyCustomHeader",
      },
    );
  }

  signComplete() {
    debugPrint("Telling the server completion of the signature");
    http.put("http://la6.scottz.net:8080/putState", headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "envelopeId": getEnv(),
      "status": "signed"
    }).then((response) {
      debugPrint(response.body.toString());
    });
    clearStuff();
  }
}
