class WithdrawInitModel {
  String currency;
  String min;
  String available;
  String notice;
  String fee_transfer;
  List<FeeModel> fees = [];

  WithdrawInitModel(this.currency, this.min, this.available, this.notice,
      this.fees, this.fee_transfer);

  factory WithdrawInitModel.parse(Map<String, dynamic> data) {
    String currency = data["currency"] ?? "";
    String min = "0";
    String notice = data["notice"] ?? "";
    String available = "0";
    String fee_transfer = '0';
    var m = data["min"];
    if (m != null && m != "") {
      min = (m is int) ? m.toDouble() : m;
    }
    var a = data["account"];
    if (a != null) {
      available = a;
    }
    var f = data["fee_transfer"];
    if (f != null) {
      fee_transfer = (f is String) ? f : '0';
    }

    List<FeeModel> fees = [];
    var fee = data["fee"];
    if (fee != null && fee is Map) {
      var keys = fee.keys.toList();
      keys.forEach((key) {
        var value = fee[key];
        if (value != null && value is Map) {
          String fee2 = value["fee"] ?? "";
          double rate = 0;
          var r = value["rate"];
          if (r != null) {
            rate = r is int ? r.toDouble() : r;
          }
          double amount = 0;
          var a = value["amount"];
          if (a != null) {
            amount = a is int ? a.toDouble() : a;
          }
          FeeModel model = FeeModel(key, fee2, rate, amount);
          fees.add(model);
        }
      });
    }

    return WithdrawInitModel(
        currency, min, available, notice, fees, fee_transfer);
  }
}

class FeeModel {
  String blockchain;
  String feeDes;
  double feePercent;
  double gasFee;

  FeeModel(this.blockchain, this.feeDes, this.feePercent, this.gasFee);
}
