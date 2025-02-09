class CardInfoModel {
  String level_name;
  int level;
  String recharge_fee;
  String recharge_fee_unit;
  String open_fee;
  String open_fee_unit;
  String first_limit_fee;
  String first_limit_fee_unit;
  String month_fee;
  String month_fee_unit;
  String upgrade_fee;
  String upgrade_fee_unit;
  String month_limit;
  String month_limit_unit;
  String recommend_fee;
  String recommend_fee_unit;

  CardInfoModel(
      this.level_name,
      this.level,
      this.recharge_fee,
      this.recharge_fee_unit,
      this.open_fee,
      this.open_fee_unit,
      this.first_limit_fee,
      this.first_limit_fee_unit,
      this.month_fee,
      this.month_fee_unit,
      this.upgrade_fee,
      this.upgrade_fee_unit,
      this.month_limit,
      this.month_limit_unit,
      this.recommend_fee,
      this.recommend_fee_unit);

  factory CardInfoModel.parse(Map<String, dynamic> dic) {
    String level_name = dic["level_name"] ?? "";
    int level = 0;
    var le = dic["level"];
    if (le != null && le is int) {
      level = le;
    }
    String recharge_fee = dic["recharge_fee"] ?? "";
    String recharge_fee_unit = dic["recharge_fee_unit"] ?? "";
    String open_fee = dic["open_fee"] ?? "";
    String open_fee_unit = dic["open_fee_unit"] ?? "";
    String first_limit_fee = dic["first_limit_fee"] ?? "";
    String first_limit_fee_unit = dic["first_limit_fee_unit"] ?? "";
    String month_fee = dic["month_fee"] ?? "";
    String month_fee_unit = dic["month_fee_unit"] ?? "";
    String upgrade_fee = dic["upgrade_fee"] ?? "";
    String upgrade_fee_unit = dic["upgrade_fee_unit"] ?? "";
    String month_limit = dic["month_limit"] ?? "";
    String month_limit_unit = dic["month_limit_unit"] ?? "";
    String recommend_fee = dic["recommend_fee"] ?? "";
    String recommend_fee_unit = dic["recommend_fee_unit"] ?? "";

    return CardInfoModel(
        level_name,
        level,
        recharge_fee,
        recharge_fee_unit,
        open_fee,
        open_fee_unit,
        first_limit_fee,
        first_limit_fee_unit,
        month_fee,
        month_fee_unit,
        upgrade_fee,
        upgrade_fee_unit,
        month_limit,
        month_limit_unit,
        recommend_fee,
        recommend_fee_unit);
  }
}
