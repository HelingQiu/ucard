class TransferModel {
  int type; // 0:deposit   1:withdraw
  int transferId;
  String currency;
  String money;
  DateTime time;
  String status;
  String address;

  TransferModel(this.type, this.transferId, this.currency, this.money,
      this.time, this.status, this.address);

  factory TransferModel.parse(int type, Map<String, dynamic> data) {
    int transferId = 0;
    var d1 = data["id"];
    if (d1 != null) {
      transferId = d1;
    }
    String currency = data["currency"] ?? "";
    String money = data["money"] ?? "0";
    DateTime time = DateTime.now();
    var at = data["add_time_int"];
    if (at != null && at is int) {
      time = DateTime.fromMillisecondsSinceEpoch(at * 1000);
    }
    String status = data["status"] ?? "";
    String address = data["address"] ?? "";

    return TransferModel(
        type, transferId, currency, money, time, status, address);
  }
}
