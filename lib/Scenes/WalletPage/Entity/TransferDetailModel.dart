class TransferDetailModel {
  // int transferId;
  int type; // 0:deposit   1:withdraw
  String currency;
  String txid;
  String address;
  String money;
  double gas;
  int time;
  String status;
  String blockchain;
  int statusType;

  TransferDetailModel(
      this.type,
      this.currency,
      this.txid,
      this.address,
      this.money,
      this.gas,
      this.time,
      this.status,
      this.blockchain,
      this.statusType);

  factory TransferDetailModel.parse(int type, Map<String, dynamic> data) {
    double gas = 0.0;
    int statusType = 0;
    String currency = data["currency"] ?? "";
    String txid = data["txid"] ?? "";
    String address = data["address"] ?? "";
    String money = "";
    var m = data["money"];
    if (m != null) {
      if (m is String) {
        money = m;
      } else {
        money = "${m}";
      }
    }
    var g = data["gas"];
    if (g != null) {
      gas = g is int ? g.toDouble() : g;
    }
    int time = data["add_time_int"] ?? "";
    String status = data["status"] ?? "";
    String blockchain = data["agreement"] ?? "";
    var st = data["status_id"];
    if (st != null && st is int) {
      statusType = st;
    }

    return TransferDetailModel(type, currency, txid, address, money, gas, time,
        status, blockchain, statusType);
  }
}
