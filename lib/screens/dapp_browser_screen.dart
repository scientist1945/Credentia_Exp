import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DappBrowserScreen extends StatefulWidget {
  final String initialUrl;
  const DappBrowserScreen({Key? key, required this.initialUrl}) : super(key: key);

  @override
  State<DappBrowserScreen> createState() => _DappBrowserScreenState();
}

class _DappBrowserScreenState extends State<DappBrowserScreen> {
  late final WebViewController _controller;

  final String _injectedWeb3Provider = '''
    window.ethereum = {
      isMetaMask: true,
      request: async ({ method, params }) => {
        return new Promise((resolve, reject) => {
          const payload = JSON.stringify({ method, params });
          window.CredentiaBridge.postMessage(payload);
        });
      }
    };
  ''';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'CredentiaBridge',
        onMessageReceived: (JavaScriptMessage message) {
          _handleDappRequest(message.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _controller.runJavaScript(_injectedWeb3Provider);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  void _handleDappRequest(String payload) {
    try {
      final request = jsonDecode(payload);
      final method = request['method'];
      
      if (method == 'eth_requestAccounts') {
        _showApprovalDialog("La dApp quiere conectarse a tu wallet", () {
          Navigator.pop(context);
        });
      }
      
      if (method == 'eth_sendTransaction') {
         _showApprovalDialog("La dApp quiere enviar una transacción", () {
           Navigator.pop(context);
         });
      }
    } catch (e) {
      print("Error parseando request: $e");
    }
  }

  void _showApprovalDialog(String message, VoidCallback onApprove) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Firma requerida'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Rechazar', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: onApprove,
            child: const Text('Aprobar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navegador Web3')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
