class AddressModel {
  String currency;
  String address;
  String blockchain;
  String notice;

  AddressModel(this.currency, this.address, this.blockchain, this.notice);

  factory AddressModel.parse(String currency, Map<String, dynamic> dic) {
    String address = dic["address"] ?? "";
    String blockchain = dic["agreement"] ?? "";
    String notice = dic["notice"] ?? "";
    return AddressModel(currency, address, blockchain, notice);
  }
}
