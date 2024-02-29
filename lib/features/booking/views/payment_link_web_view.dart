import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentLinkView extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const PaymentLinkView());
  const PaymentLinkView({Key? key}) : super(key: key);

  @override
  State<PaymentLinkView> createState() => _PaymentLinkViewState();
}

class _PaymentLinkViewState extends State<PaymentLinkView> {
  String getUsername() {
    final user = FirebaseAuth.instance.currentUser;
    final email = user!.email;
    final username = email!.substring(0, email.indexOf('@'));
    return username;
  }

  WebViewController controller(String username) => WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar
          log('Loading: $progress%');
        },
        onPageStarted: (String url) {
          log('Started: $url');
        },
        onPageFinished: (String url) {
          log('Finished: $url');
        },
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          log('Request: ${request.url}');
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(
      Uri.parse('https://buy.stripe.com/test_bIY5o9f3S5CKaicdR6'),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Check Out '),
            centerTitle: true,
            backgroundColor: Colors.grey.shade100,
            elevation: 2,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          body: WebViewWidget(
            controller: controller(getUsername()),
          ),
        ),
      ),
    );
  }
}
