import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hop_app/main.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Browser extends StatelessWidget {
  const Browser({Key? key}) : super(key: key);

  static const routeName = '/browser';

  @override
  Widget build(BuildContext context) {
    final Completer<WebViewController> _controller =
        Completer<WebViewController>();
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return WillPopScope(
      onWillPop: () async {
        WebViewController webViewController = await _controller.future;
        bool canNavigate = await webViewController.canGoBack();
        if (canNavigate) {
          webViewController.goBack();
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: (Text(args.title)),
          actions: <Widget>[
          
            TextButton(
              style: style,
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close),
            )
          ],
        ),
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: args.url,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}




// Future<bool> _exitApp(BuildContext context) async {
//   WebViewController webViewController = await _controller.future;
//   if (await webViewController.canGoBack()) {
//     print("onwill goback");
//     webViewController.goBack();
//   } else {
//     Scaffold.of(context).showSnackBar(
//       const SnackBar(content: Text("No back history item")),
//     );
//     return Future.value(false);
//   }
// }
