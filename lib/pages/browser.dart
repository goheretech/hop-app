import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import '/screen_arguments.dart';

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

    print("URL: ${args.url}");

    // Instantiate WebViewController
    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(args.url));

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
          title: Text(args.title),
          backgroundColor: Colors.blue[900],
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
        body: WebViewWidget(
          controller: controller,
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
