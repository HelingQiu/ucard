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

class CountryModel {
  String code;
  String interarea;
  String countryname;

  CountryModel(this.code, this.interarea, this.countryname);

  factory CountryModel.parse(Map<String, dynamic> dic) {
    String code = dic["code"] ?? "";
    String interarea = dic["interarea"] ?? "";
    String countryname = dic["countryname"] ?? "";

    return CountryModel(code, interarea, countryname);
  }
}
