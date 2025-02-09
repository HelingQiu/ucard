class CardTypeModel {
  String cardBin;
  String cardType;
  String cardDes;
  int toApplyUser;

  CardTypeModel(this.cardBin, this.cardType, this.cardDes, this.toApplyUser);

  factory CardTypeModel.parse(Map<String, dynamic> dic) {
    String cardBin = dic["cardBin"] ?? "";
    String cardType = dic["cardType"] ?? "";
    String cardDes = dic["cardDes"] ?? "";
    int toApplyUser = 0;
    var toau = dic["toApplyUser"];
    if (toau != null && toau is int) {
      toApplyUser = toau;
    }
    return CardTypeModel(cardBin, cardType, cardDes, toApplyUser);
  }
}
