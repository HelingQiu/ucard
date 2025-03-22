class CardTypeModel {
  String cardBin;
  String cardType;
  String cardDes;
  int toApplyUser;
  bool isPhysial;
  int service;
  String currency;
  String limit;
  int exist;

  CardTypeModel(this.cardBin, this.cardType, this.cardDes, this.toApplyUser,
      this.isPhysial, this.service, this.currency, this.limit, this.exist);

  factory CardTypeModel.parse(Map<String, dynamic> dic) {
    String cardBin = dic["cardBin"] ?? "";
    String cardType = dic["cardType"] ?? "";
    String cardDes = dic["des"] ?? "";
    int toApplyUser = 0;
    var toau = dic["toApplyUser"];
    if (toau != null && toau is int) {
      toApplyUser = toau;
    }

    int service = 1;
    var serv = dic["service"];
    if (serv != null && serv is int) {
      service = serv;
    }
    String currency = dic["currency"] ?? "";
    String limit = dic["limit"] ?? "";

    int exist = 0;
    var ex = dic["exist"];
    if (ex != null && ex is int) {
      exist = ex;
    }

    return CardTypeModel(cardBin, cardType, cardDes, toApplyUser, false,
        service, currency, limit, exist);
  }
}
