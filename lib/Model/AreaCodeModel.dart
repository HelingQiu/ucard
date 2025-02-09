class AreaCodeModel {
  String code = '';
  String interarea = '';
  String countryName = '';

  AreaCodeModel(this.code, this.interarea, this.countryName);

  factory AreaCodeModel.parse(Map<String, dynamic> dic) {
    String code = dic["code"] ?? "";
    String interarea = dic["interarea"] ?? "";
    String countryName = dic["countryname"] ?? "";
    return AreaCodeModel(code, interarea, countryName);
  }
}
