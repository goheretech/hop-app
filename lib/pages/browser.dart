import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hop_app/main.dart';

class Browser extends StatelessWidget {
  const Browser({Key? key}) : super(key: key);

  static const routeName = '/browser';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        appBar: AppBar(
          title: (Text(args.title)),
        ),
        body: _buildWebView(args.url),
      ),
    );
  }
}

Widget _buildWebView(String url) {
  return WebView(
    javascriptMode: JavascriptMode.unrestricted,
    initialUrl: url,
  );
}

Future<bool> _exitApp(BuildContext context) async {
  if (await controllerGlobal.canGoBack()) {
    print("onwill goback");
    controllerGlobal.goBack();
  } else {
    Scaffold.of(context).showSnackBar(
      const SnackBar(content: Text("No back history item")),
    );
    return Future.value(false);
  }
}
