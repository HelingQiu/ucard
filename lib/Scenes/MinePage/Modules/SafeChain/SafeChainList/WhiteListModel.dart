class WhiteListModel {
  int whiteId;

  String address;
  String currency;
  String agreement;
  String alias;

  WhiteListModel(
    this.whiteId,
    this.address,
    this.currency,
    this.agreement,
    this.alias,
  );
  factory WhiteListModel.parse(Map<String, dynamic> data) {
    int whiteId = 0;
    var d1 = data["id"];
    if (d1 != null) {
      whiteId = d1;
    }
    String address = data["address"] ?? "";
    String currency = data["currency"] ?? "";
    String agreement = data["agreement"] ?? "";
    String alias = data["alias"] ?? "";

    return WhiteListModel(
      whiteId,
      address,
      currency,
      agreement,
      alias,
    );
  }
}
