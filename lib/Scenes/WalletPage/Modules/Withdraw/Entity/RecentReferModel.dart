class RecentReferModel {
  int recentId;
  String currency;
  String money;
  int to_uid;
  String to_user_name;
  String created_at;
  RecentReferModel(this.recentId, this.currency, this.money, this.to_uid,
      this.to_user_name, this.created_at);

  factory RecentReferModel.parse(Map<String, dynamic> data) {
    int recentId = 0;
    int a = data["id"];
    if (a != null) {
      recentId = a;
    }
    String currency = data['currency'];
    String money = data['money'];
    int to_uid = 0;
    int u = data["to_uid"];
    if (u != null) {
      to_uid = u;
    }
    String to_user_name = data['to_user_name'];
    String created_at = data['created_at'];

    return RecentReferModel(
        recentId, currency, money, to_uid, to_user_name, created_at);
  }
}
