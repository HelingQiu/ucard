class TransCardrechargeModel {
  int rechargeId;

  String trans_code;
  String trans_code_str;
  String money;
  String created_at;
  String currency;
  String flag;
  DateTime created_at_int;

  TransCardrechargeModel(
      this.rechargeId,
      this.trans_code,
      this.trans_code_str,
      this.money,
      this.created_at,
      this.currency,
      this.flag,
      this.created_at_int);
  factory TransCardrechargeModel.parse(Map<String, dynamic> data) {
    int rechargeId = 0;
    var d1 = data["id"];
    if (d1 != null) {
      rechargeId = d1;
    }
    String trans_code = data["trans_code"] ?? "";
    String trans_code_str = data["trans_code_str"] ?? "";
    String money = data["money"] ?? "";
    String created_at = data["created_at"] ?? "";
    String currency = data["currency"] ?? "";
    String flag = data["flag"] ?? "";
    DateTime created_at_int = DateTime.now();
    var at = data["created_at_int"];
    if (at != null && at is int) {
      created_at_int = DateTime.fromMillisecondsSinceEpoch(at * 1000);
    }

    return TransCardrechargeModel(rechargeId, trans_code, trans_code_str, money,
        created_at, currency, flag, created_at_int);
  }
}
