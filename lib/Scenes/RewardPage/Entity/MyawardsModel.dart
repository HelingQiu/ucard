class MyawardsModel {
  String user_name;
  String currency;
  String money;
  String created_at;
  int card_count;

  MyawardsModel(
    this.user_name,
    this.currency,
    this.money,
    this.created_at,
    this.card_count,
  );

  factory MyawardsModel.parse(Map<String, dynamic> dic) {
    String user_name = dic["user_name"] ?? "";
    String currency = dic["currency"] ?? "";
    String money = dic["money"] ?? "";
    String created_at = dic["created_at"] ?? "";
    int card_count = 0;
    var count = dic["card_count"];
    if (count != null && count is int) {
      card_count = count;
    }

    return MyawardsModel(
      user_name,
      currency,
      money,
      created_at,
      card_count,
    );
  }
}
