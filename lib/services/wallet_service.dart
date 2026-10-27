import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants.dart';

class WalletService {
  final Web3Client ethClient;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  WalletService() : ethClient = Web3Client(AppConstants.expanseRpcUrl, Client());

  Future<String> createNewWallet() async {
    String mnemonic = bip39.generateMnemonic();
    await secureStorage.write(key: 'mnemonic', value: mnemonic);
    return mnemonic;
  }

  Future<EtherAmount> getBalance(String address) async {
    final ethAddress = EthereumAddress.fromHex(address);
    return await ethClient.getBalance(ethAddress);
  }
}
