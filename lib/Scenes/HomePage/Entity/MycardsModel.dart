import 'dart:ffi';

class MycardsModel {
  String card_order;
  String card_type;
  int level;
  String level_str;
  String card_name;
  String status;
  String card_no;
  String balance;
  String expiry_date;
  String expiry_year;
  String expiry_month;
  String card_cvv;
  int is_open;
  int hide_name;
  String close_fee;
  String close_fee_unit;
  String img1;
  String img2;
  String img_left_top;
  String img_left_bottom;
  String img_card_center;
  String img_card_bg;
  int service;
  String hold_status;

  // const STATUS_WA = 'WA';//审核中
  // const STATUS_P = 'P';//未制卡
  // const STATUS_E = 'E';//未售出
  // const STATUS_N = 'N';//已售出但未激活
  // const STATUS_A = 'A';//售出並已激活
  // const STATUS_X = 'X';//已過期
  // const STATUS_T = 'T';//客戶已轉用另一張卡
  // const STATUS_K = 'K';//口頭掛失
  // const STATUS_L = 'L';//正式掛失
  // const STATUS_R = 'R';//已退卡

  MycardsModel(this.card_order,
      this.card_type,
      this.level,
      this.level_str,
      this.card_name,
      this.status,
      this.card_no,
      this.balance,
      this.expiry_date,
      this.expiry_year,
      this.expiry_month,
      this.card_cvv,
      this.is_open,
      this.hide_name,
      this.close_fee,
      this.close_fee_unit,
      this.img1,
      this.img2,
      this.img_left_top,
      this.img_left_bottom,
      this.img_card_center,
      this.img_card_bg,
      this.service,
      this.hold_status,);

  factory MycardsModel.parse(Map<String, dynamic> dic) {
    String card_order = dic["card_order"] ?? "";
    String card_type = dic["card_type"] ?? "";
    int level = 0;
    var le = dic["level"];
    if (le != null && le is int) {
      level = le;
    }
    String level_str = dic["level_str"] ?? "";
    String card_name = dic["card_name"] ?? "";
    String status = dic["status"] ?? "";
    String card_no = dic["card_no"] ?? "";
    String balance = dic["balance"].toString() ?? "";
    // double balance = 0;
    // var bl = dic["balance"];
    // if (bl != null && bl is double) {
    //   balance = bl;
    // }
    String expiry_date = dic["expiry_date"] ?? "";
    String expiry_year = dic["expiry_year"] ?? "";
    String expiry_month = dic["expiry_month"] ?? "";
    String card_cvv = dic["card_cvv"] ?? "";
    int is_open = 0;
    var op = dic["is_open"];
    if (op != null && op is int) {
      is_open = op;
    }

    int hide_name = 0;
    var hn = dic["hide_name"];
    if (hn != null && hn is int) {
      hide_name = hn;
    }

    String close_fee = dic["close_fee"] ?? "";
    String close_fee_unit = dic["close_fee_unit"] ?? "";

    String img1 = dic["img1"] ?? "";
    String img2 = dic["img2"] ?? "";

    String img_left_top = dic["img_left_top"] ?? "";
    String img_left_bottom = dic["img_left_bottom"] ?? "";
    String img_card_center = dic["img_card_center"] ?? "";
    String img_card_bg = dic["img_card_bg"] ?? "";

    int service = 1;
    var ser = dic["service"];
    if (ser != null && ser is int) {
      service = ser;
    }
    String hold_status = dic["hold_status"] ?? "";

    return MycardsModel(
      card_order,
      card_type,
      level,
      level_str,
      card_name,
      status,
      card_no,
      balance,
      expiry_date,
      expiry_year,
      expiry_month,
      card_cvv,
      is_open,
      hide_name,
      close_fee,
      close_fee_unit,
      img1,
      img2,
      img_left_top,
      img_left_bottom,
      img_card_center,
      img_card_bg,
      service,
      hold_status,
    );
  }
}
