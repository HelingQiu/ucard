class CardRechargeDetailModel {
  String card_type;
  int level;
  String card_level_str;
  String card_no;
  String money;
  String money_currency;
  String received_money;
  String received_money_currency;
  String fee;
  String fee_currency;
  String created_at;
  int status;
  DateTime created_at_int;

  CardRechargeDetailModel(
    this.card_type,
    this.level,
    this.card_level_str,
    this.card_no,
    this.money,
    this.money_currency,
    this.received_money,
    this.received_money_currency,
    this.fee,
    this.fee_currency,
    this.created_at,
    this.status,
      this.created_at_int,
  );

  factory CardRechargeDetailModel.parse(Map<String, dynamic> data) {
    String card_type = data["card_type"] ?? "";
    int level = 0;
    var d2 = data["level"];
    if (d2 != null) {
      level = d2;
    }
    String card_level_str = data["card_level_str"] ?? "";
    String card_no = data["card_no"] ?? "";
    String money = data["money"] ?? "";
    String money_currency = data["money_currency"] ?? "";
    String received_money = data["received_money"] ?? "";
    String received_money_currency = data["received_money_currency"] ?? "";
    String fee = data["fee"] ?? "";
    String fee_currency = data["fee_currency"] ?? "";
    String created_at = data["created_at"] ?? "";
    int status = 0;
    var st = data["status"];
    if (st != null) {
      status = st;
    }
    DateTime created_at_int = DateTime.now();
    var at = data["created_at_int"];
    if (at != null && at is int) {
      created_at_int = DateTime.fromMillisecondsSinceEpoch(at * 1000);
    }

    return CardRechargeDetailModel(
      card_type,
      level,
      card_level_str,
      card_no,
      money,
      money_currency,
      received_money,
      received_money_currency,
      fee,
      fee_currency,
      created_at,
      status,
      created_at_int,
    );
  }
}
