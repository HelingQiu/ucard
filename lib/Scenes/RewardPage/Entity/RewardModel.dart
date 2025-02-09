class RewardModel {
  String my_code;
  String total_money;
  String awards_rate;
  String currency;
  int invited;
  int applied;
  String share;
  int recharge;
  int show_award;

  RewardModel(this.my_code, this.total_money, this.awards_rate, this.currency,
      this.invited, this.applied, this.share, this.recharge, this.show_award);

  factory RewardModel.parse(Map<String, dynamic> dic) {
    String my_code = dic["my_code"] ?? "";
    String total_money = dic["total_money"] ?? "";
    String awards_rate = dic["awards_rate"] ?? "";
    String currency = dic["currency"] ?? "";
    int invited = 0;
    var invite = dic["invited"];
    if (invite != null && invite is int) {
      invited = invite;
    }
    int applied = 0;
    var appliy = dic["applied"];
    if (appliy != null && appliy is int) {
      applied = appliy;
    }
    String share = dic["share"] ?? "";
    int recharge = 0;
    var reCount = dic["recharge"];
    if (reCount != null && reCount is int) {
      recharge = reCount;
    }
    int show_award = 0;
    var show_award0 = dic["show_award"];
    if (show_award0 != null && show_award0 is int) {
      show_award = show_award0;
    }
    return RewardModel(my_code, total_money, awards_rate, currency, invited,
        applied, share, recharge, show_award);
  }
}
