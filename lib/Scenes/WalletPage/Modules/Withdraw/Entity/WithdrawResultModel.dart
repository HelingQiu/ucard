
class WithdrawResultModel {
  String currency;
  double amount;
  double actualAmount;
  double fee;
  String blockChain;
  String address;
  String txid;
  int createTime;
  String status;

  WithdrawResultModel(this.currency, this.amount, this.actualAmount, this.fee, this.blockChain,
      this.address, this.txid, this.createTime, this.status);

  factory WithdrawResultModel.parse(Map<String, dynamic> data) {
    String currency = data["currency"] ?? "";
    double amount = 0;
    var a = data["amount"];
    if (a != null) {
      amount = double.parse(a);
    }
    double actualAmount = 0;
    var aa = data["actual_amount"];
    if (aa != null) {
      actualAmount = double.parse(aa);
    }
    double fee = 0;
    var f = data["fee"];
    if (f != null) {
      fee = double.parse(f);
    }
    String blockChain = data["agreement"] ?? "";
    String address = data["address"];
    String txid = data["txid"];
    int createTime = 0;
    var ct = data["created_at"];
    if (ct != null && ct is int) {
      createTime = ct;
    }
    String status = data["status"] ??  "";

    return WithdrawResultModel(currency, amount, actualAmount, fee, blockChain, address, txid, createTime, status);
  }
}