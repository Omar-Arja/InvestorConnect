import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CalendlyWebView extends StatefulWidget {
  final String calendlyLink;

  const CalendlyWebView({super.key, required this.calendlyLink});

  @override
  State<CalendlyWebView> createState() => _CalendlyWebViewState();
}

class _CalendlyWebViewState extends State<CalendlyWebView> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => CircularProgressIndicator(
            value: progress / 100,
            valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 76, 104, 175)),
          ),
          onPageStarted: (url) => print('Page started loading: $url'),
          onPageFinished: (url) => print('Page finished loading: $url'),
          onWebResourceError: (error) => print('Page finished loading: $error'),
        ),
      )
      ..loadRequest(Uri.parse(widget.calendlyLink));
      print(widget.calendlyLink);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Meeting'),
        backgroundColor: const Color.fromARGB(255, 76, 104, 175),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
