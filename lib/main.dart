import 'package:flutter/material.dart';
import 'screens/dapp_browser_screen.dart';

void main() {
  runApp(const CredentiaWalletApp());
}

class CredentiaWalletApp extends StatelessWidget {
  const CredentiaWalletApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Credentia EXP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Credentia EXP Wallet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance_wallet, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text('Balance: 0.00 EXP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.explore),
              label: const Text('Abrir dApp Interna'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DappBrowserScreen(
                      initialUrl: 'https://app.uniswap.org',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
