class SettlementModel {
  String recordNo;
  String originRecordNo;
  String cardId;
  String settleDate;
  String transCurrency;
  String transCurrencyAmt;
  String billCurrency;
  String billCurrencyAmt;
  String approvalCode;
  String isCredit;
  String merchantName;
  String merchantCountryCode;
  String merchantCity;
  String transDescription;

  SettlementModel(
    this.recordNo,
    this.originRecordNo,
    this.cardId,
    this.settleDate,
    this.transCurrency,
    this.transCurrencyAmt,
    this.billCurrency,
    this.billCurrencyAmt,
    this.approvalCode,
    this.isCredit,
    this.merchantName,
    this.merchantCountryCode,
    this.merchantCity,
    this.transDescription,
  );

  factory SettlementModel.parse(Map<String, dynamic> dic) {
    String recordNo = dic["recordNo"] ?? "";
    String originRecordNo = dic["originRecordNo"] ?? "";
    String cardId = dic["cardId"] ?? "";
    String settleDate = dic["settleDate"] ?? "";
    String transCurrency = dic["transCurrency"] ?? "";
    String transCurrencyAmt = dic["transCurrencyAmt"] ?? "";
    String billCurrency = dic["billCurrency"] ?? "";
    String billCurrencyAmt = dic["billCurrencyAmt"] ?? "";
    String approvalCode = dic["approvalCode"] ?? "";
    String merchantName = dic["merchantName"] ?? "";
    String isCredit = dic["isCredit"] ?? "";
    // int isCredit = 0;
    // int credit = dic["isCredit"];
    // if (credit != null && credit is int) {
    //   isCredit = credit;
    // }
    String merchantCountryCode = dic["merchantCountryCode"] ?? "";
    String merchantCity = dic["merchantCity"] ?? "";
    String transDescription = dic["transDescription"] ?? "";

    return SettlementModel(
      recordNo,
      originRecordNo,
      cardId,
      settleDate,
      transCurrency,
      transCurrencyAmt,
      billCurrency,
      billCurrencyAmt,
      approvalCode,
      isCredit,
      merchantName,
      merchantCountryCode,
      merchantCity,
      transDescription,
    );
  }
}
