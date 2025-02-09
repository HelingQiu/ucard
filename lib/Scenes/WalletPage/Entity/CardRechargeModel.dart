class CardRechargeModel {
  int rechargeId;
  int card_level;
  String card_level_str;
  String card_no;
  String card_type;
  String money;
  String created_at;
  String currency;
  DateTime created_at_int;

  CardRechargeModel(
      this.rechargeId,
      this.card_level,
      this.card_level_str,
      this.card_no,
      this.card_type,
      this.money,
      this.created_at,
      this.currency,
      this.created_at_int);
  factory CardRechargeModel.parse(Map<String, dynamic> data) {
    int rechargeId = 0;
    var d1 = data["id"];
    if (d1 != null) {
      rechargeId = d1;
    }
    int card_level = 0;
    var d2 = data["card_level"];
    if (d2 != null) {
      card_level = d2;
    }
    String card_level_str = data["card_level_str"] ?? "";
    String card_no = data["card_no"] ?? "";
    String card_type = data["card_type"] ?? "";
    String money = data["money"] ?? "";
    String created_at = data["created_at"] ?? "";
    String currency = data["currency"] ?? "";
    DateTime created_at_int = DateTime.now();
    var at = data["created_at_int"];
    if (at != null && at is int) {
      created_at_int = DateTime.fromMillisecondsSinceEpoch(at * 1000);
    }
    return CardRechargeModel(rechargeId, card_level, card_level_str, card_no,
        card_type, money, created_at, currency, created_at_int);
  }
}
