import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';

class WalletModel {
  String balance;
  String currency;

  WalletModel(this.balance, this.currency);

  factory WalletModel.parse(Map<String, dynamic> data) {
    String balance = data["balance"] ?? "";
    String currency = data["currency"] ?? "";

    return WalletModel(
      balance,
      currency,
    );
  }
}
