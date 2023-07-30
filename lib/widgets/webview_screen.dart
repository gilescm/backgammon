import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  const WebviewScreen({super.key});

  @override
  State<WebviewScreen> createState() => _WebviewScreenState();
}

class _WebviewScreenState extends State<WebviewScreen> {
  late WebViewController _controller;

  static const _deeplinkTarget = 'youtube';

  // Sorry it was the only video I could think of...
  static const _iOSDeeplink = 'youtube://watch?v=dQw4w9WgXcQ';
  static const _androidDeeplink = 'https://youtube.com/watch?v=dQw4w9WgXcQ';

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    _controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.contains(_deeplinkTarget)) {
              _onDeeplinkAttempt(request.url);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://google.com'));
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.dispose();
  }

  Future<void> _onDeeplinkAttempt(String url) async {
    // defaultTargetPlatform is used here so the logic can be more easily tested
    // i.e. via debugDefaultTargetPlatformOverride = ...
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await launchUrl(
        Uri.parse(_iOSDeeplink),
        mode: LaunchMode.externalApplication,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      await launchUrl(
        Uri.parse(_androidDeeplink),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
