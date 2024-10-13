import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  final String url = Get.arguments; // Mendapatkan URL dari argumen

  @override
  void initState() {
    super.initState();
    // Inisialisasi WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url)); // Memuat URL dari argumen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather WebView'),
        centerTitle: true,
      ),
      body: WebViewWidget(controller: _controller), // Menggunakan WebViewWidget
    );
  }
}
