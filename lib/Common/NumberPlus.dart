import 'package:intl/intl.dart';
import 'dart:math';

import '../Data/AppStatus.dart';

class NumberPlus {
  static List<double> chartPriceSpaceIncrement(double high, double low) {
    //return [0] increment  [1] highest price   [2]line space number
    var space = high - low;
    // debugPrint("high = $high, low = $low,  space = $space");
    if (space == 0) {
      high = high * 1.0001;
      low = low * 0.9999;
    } else {
      high = high + space * 0.02;
      if ((low - space * 0.02) < 0) {
        if (low > 0) {
          low = 0;
        }
      } else {
        low = low - space * 0.02;
      }
      // high = high*1.01;
      // low = low*0.99;
    }
    space = high - low;
    var minIncrement = space / 5;
    // var maxIncrement = space/6;
    var a = space;
    double i = 1;
    while (a > 10 || a < 1) {
      if (a > 10) {
        i = i * 10;
      } else {
        i = i * 0.1;
      }
      a = space / i;
    }
    var b = i;
    while (b < minIncrement) {
      b += i;
    }
    var high2 = (high / b).ceil() * b;
    var low2 = (low / b).floor() * b;
    // var lineNum = ((high-low)/b).ceil();
    var lineNum = (high / b).ceil() - (low / b).floor();
    while (lineNum < 5) {
      b = b / 2;
      high2 = (high / b).ceil() * b;
      low2 = (low / b).floor() * b;
      lineNum = (high / b).ceil() - (low / b).floor();
    }
    return [b, high2, low2, lineNum.toDouble()];
  }

  static String removeZero(String num) {
    RegExp regex = RegExp(r"([.]*0+)(?!.*\d)");

    return num.toString().replaceAll(regex, '');
  }

  static String priceSymbol(double price) {
    if (price > 0) {
      return "+";
    }
    return "";
  }

//给邮箱和手机加***处理
  static String getSecurityEmail(String email) {
    email = (email == "" ? "423234" : email);
    List<String> list1 = email.split('@');

    String str, str1, str2;
    if (list1.length == 1) {
      //为手机号码时
      List<String> list2 = email.split(' ');
      str = list2[0];
      if (list2[1].length > 2) {
        str1 = list2[1].substring(0, 2);
        str2 = list2[1].substring(list2[1].length - 2, list2[1].length);
      } else {
        str1 = list2[1];
        str2 = "";
        return "$str $str1";
      }
      email = "$str $str1***$str2";
      return email;
    }

    if (list1[0].length < 4) {
      str = list1[0].substring(0, 1);
      str1 = list1[0].substring(list1[0].length - 1, list1[0].length);

      email = "$str***$str1@${list1[1]}";
    } else {
      str = list1[0].substring(0, 2);
      str1 = list1[0].substring(list1[0].length - 2, list1[0].length);

      email = "$str***$str1@${list1[1]}";
    }

    print("New String: $email");

    return email;
  }

  static String displayPrice(double price, String currency) {
    // return "${double.parse(price.toStringAsFixed(AppStatus.shared.precisionNum(currency)))}";
    String formatStr = '#,###.##';
    int priceSize = 2; //AppStatus.shared.priceSize(currency);
    for (int i = 2; i < priceSize; i++) {
      formatStr = formatStr + "#";
    }
    var fac = pow(10, priceSize);
    var p = (price * fac).floor().toDouble() / fac;
    return NumberFormat(formatStr).format(p);
  }

  ///24h量只显示2位小数单独处理
  static String display24HPrice(double price, String currency) {
    // return "${double.parse(price.toStringAsFixed(AppStatus.shared.precisionNum(currency)))}";
    String formatStr = '#,###.##';
    int priceSize = 2;
    for (int i = 2; i < priceSize; i++) {
      formatStr = formatStr + "#";
    }
    var fac = pow(10, priceSize);
    var p = (price * fac).floor().toDouble() / fac;
    return NumberFormat(formatStr).format(p);
  }

  static String displayValue(double value, String currency) {
    String formatStr = '#,###.##';
    int precisionNum = 2; //AppStatus.shared.precisionNum(currency);
    for (int i = 2; i < precisionNum; i++) {
      formatStr = formatStr + "#";
    }
    var fac = pow(10, precisionNum);
    var b = (value * fac).floor().toDouble() / fac;
    var c = NumberFormat(formatStr).format(b);
    return c;
    // removeZero(value.toStringAsFixed(AppStatus.shared.quantitySize(currency)));
  }

  static String displayNumber(double number, String currency) {
    String formatStr = '#,###.##';
    int precisionNum = 2; //AppStatus.shared.precisionNum(currency);
    for (int i = 2; i < precisionNum; i++) {
      formatStr = formatStr + "#";
    }
    // debugPrint("number = $number,  formatstr = $formatStr");
    return NumberFormat(formatStr).format(number);
    // debugPrint("str= $str");
    // return removeZero(str);
  }

  static String positiveOrNegative(double number) {
    if (number < 0) {
      return "-";
    } else if (number > 0) {
      return "+";
    }
    return "";
  }

  static String inputNumber(String number, String currency) {
    int quantitySize = 4; //AppStatus.shared.quantitySize(currency);
    double dn = double.tryParse(number) ?? 0.0;
    var fac = pow(10, quantitySize);
    dn = (dn * fac).floor().toDouble() / fac;
    return dn.toString();
  }
}
