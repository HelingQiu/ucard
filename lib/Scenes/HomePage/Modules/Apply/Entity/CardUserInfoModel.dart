class CardUserInfoModel {
  String first_name;
  String last_name;
  String email;
  String phone;
  String billing_city;
  String billing_state;
  String billing_address;
  String billing_zipcode;

  CardUserInfoModel(
      this.first_name,
      this.last_name,
      this.email,
      this.phone,
      this.billing_city,
      this.billing_state,
      this.billing_address,
      this.billing_zipcode);

  factory CardUserInfoModel.parse(Map<String, dynamic> dic) {
    String first_name = dic["first_name"] ?? "";
    String last_name = dic["last_name"] ?? "";
    String email = dic["email"] ?? "";
    String phone = dic["phone"] ?? "";
    String billing_city = dic["billing_city"] ?? "";
    String billing_state = dic["billing_state"] ?? "";
    String billing_address = dic["billing_address"] ?? "";
    String billing_zipcode = dic["billing_zipcode"] ?? "";

    return CardUserInfoModel(first_name, last_name, email, phone, billing_city,
        billing_state, billing_address, billing_zipcode);
  }
}
