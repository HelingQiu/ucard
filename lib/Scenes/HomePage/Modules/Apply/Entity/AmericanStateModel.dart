class AmericanStateModel {
  String title;
  String jx;

  AmericanStateModel(this.title, this.jx);

  factory AmericanStateModel.parse(Map<String, dynamic> dic) {
    String title = dic["title"] ?? "";
    String jx = dic["jx"] ?? "";

    return AmericanStateModel(title, jx);
  }
}
