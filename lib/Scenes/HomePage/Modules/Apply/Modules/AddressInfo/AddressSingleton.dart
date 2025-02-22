class AddressSingleton {
  static AddressSingleton shared = AddressSingleton._internal();

  factory AddressSingleton() {
    return shared;
  }

  AddressSingleton._internal() {}

  var shippingDict;
  var mailingDict;
  var residentialDict;
}
