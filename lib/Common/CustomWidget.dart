import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ucardtemp/Common/ColorUtil.dart';

import '../Data/AppStatus.dart';

class CustomWidget {
  Widget LargeSmallNumber(String number, String suffix, double largeSize,
      double smallSize, Color textColor, double bottomOffset,
      {String prefix = "", Alignment alignment = Alignment.centerLeft}) {
    var ns = number.split('.');
    String fractionalPart = "";
    if (ns.length > 1) {
      fractionalPart = ".${ns[1]}";
    }
    int n = int.tryParse(ns[0]) ?? 0;
    return Container(
      alignment: alignment,
      child: FittedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              (n != 0)
                  ? "${prefix}${NumberFormat('#,###').format(n)}"
                  : "${prefix}${ns[0]}",
              style: TextStyle(
                  fontSize: largeSize,
                  color: textColor,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: bottomOffset),
              child: Text(
                "$fractionalPart$suffix",
                style: TextStyle(fontSize: smallSize, color: textColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget SearchBar() {
    return ListTile(
      leading: Icon(
        Icons.search_rounded,
        color: Colors.white,
        size: 24,
      ),
      title: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(color: AppStatus.shared.textGreyColor),
          border: InputBorder.none,
        ),
      ),
      trailing: IconButton(onPressed: () {}, icon: Icon(Icons.close_rounded)),
    );
  }

  Widget EventStatusView(int status) {
    return Container(
      // width: 42,
      height: 24,
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: status == 1
                ? Color.fromRGBO(15, 59, 79, 1)
                : (status == 2
                    ? Color.fromRGBO(66, 59, 28, 1)
                    : Color.fromRGBO(47, 50, 60, 1)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 8),
            child: (status == 1)
                ? Row(
                    children: [
                      Container(
                        width: 20,
                        height: 10,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(0, 201, 255, 1),
                            shape: BoxShape.circle),
                      ),
                      Text("In Progress".tr(),
                          style: TextStyle(
                              color: Color.fromRGBO(0, 201, 255, 1),
                              fontSize: 14))
                    ],
                  )
                : (status == 2
                    ? Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 205, 0, 1),
                                shape: BoxShape.circle),
                          ),
                          Text("Not Started".tr(),
                              style: TextStyle(
                                  color: Color.fromRGBO(255, 205, 0, 1),
                                  fontSize: 14))
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(159, 159, 159, 1),
                                shape: BoxShape.circle),
                          ),
                          Text("Expired".tr(),
                              style: TextStyle(
                                  color: Color.fromRGBO(159, 159, 159, 1),
                                  fontSize: 14))
                        ],
                      )),
          )),
    );
  }
}

class SendCodeButton extends StatefulWidget {
  VoidCallback defaultCallback; //
  int sendType =
      0; // 0: register-email  1: register-phone   2: forget-email   3:forget-phone
  bool enable = true;
  Color color;
  int style; //0: register yellow style   1: login blue small
  double fontSize = 14;
  bool sendCodeSuccess = true;
  bool isStartCountdown = false;

  SendCodeButton(this.sendType, this.isStartCountdown, this.enable, this.color,
      this.defaultCallback,
      {this.style = 0, this.fontSize = 14, this.sendCodeSuccess = true});

  @override
  _SendCodeButtonState createState() => _SendCodeButtonState();
}

class _SendCodeButtonState extends State<SendCodeButton> {
  Timer? _timer;
  int times = 0;
  bool canResend = false;
  bool showCountDown = false;

  _SendCodeButtonState() {
    times = 0;
    cancelTimer();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isStartCountdown) {
      canResend = false;
      showCountDown = true;
      beginCountDown();
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    showCountDown = false;
    if (widget.sendCodeSuccess == false) {
      cancelTimer();
    } else if (times > 0) {
      showCountDown = true;
    }
    return Container(
      child: ElevatedButton(
        child: Center(
          child: FittedBox(
            child: Text(
              widget.sendType == 0
                  ? (canResend
                      ? "Resend".tr()
                      : (showCountDown ? "${times}s" : "Send".tr()))
                  : (canResend
                      ? "Resend".tr()
                      : (showCountDown
                          ? "${"Resend".tr()}(${times}s)"
                          : "Send".tr())),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: widget.sendType == 0
                      ? Colors.white
                      : showCountDown
                          ? AppStatus.shared.textGreyColor
                          : AppStatus.shared.bgBlueColor,
                  fontSize: widget.fontSize),
            ),
            fit: BoxFit.scaleDown,
          ),
        ),
        style: widget.sendType == 0
            ? ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: widget.enable
                    ? showCountDown
                        ? ColorsUtil.hexColor(0x4F4F4F)
                        : widget.color
                    : ColorsUtil.hexColor(0x4F4F4F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ))
            : ElevatedButton.styleFrom(
                elevation: 0, backgroundColor: widget.color),
        onPressed: () {
          if (widget.enable == true && showCountDown == false) {
            canResend = false;
            beginCountDown();
            widget.defaultCallback();
          }
        },
      ),
    );
  }

  beginCountDown() {
    const period = const Duration(seconds: 1);
    times = 60;
    setState(() {});
    _timer = Timer.periodic(period, (timer) {
      setState(() {
        times--;
      });
      if (times == 0) {
        canResend = true;
        cancelTimer();
      }
    });
  }

  cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }
}

class CountdownButton extends StatefulWidget {
  VoidCallback endCountDown;
  int seconds;

  CountdownButton(this.seconds, this.endCountDown);

  @override
  CountdownButtonState createState() => CountdownButtonState(seconds);
}

class CountdownButtonState extends State<CountdownButton> {
  Timer? _timer;
  int times;

  CountdownButtonState(this.times) {
    cancelTimer();
    beginCountDown();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showCountDown = false;
    if (times > 0) {
      showCountDown = true;
    }
    return Container(
      child: ElevatedButton(
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: Center(
            child: Text(
              showCountDown ? CountDownTime(times) : "Start now".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: showCountDown
                ? AppStatus.shared.textGreyColor
                : Color.fromRGBO(2, 87, 215, 1),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3), // <-- Radius
            )),
        onPressed: () {},
      ),
    );
  }

  beginCountDown() {
    const period = const Duration(seconds: 1);
    _timer = Timer.periodic(period, (timer) {
      if (this.mounted) {
        setState(() {
          times--;
        });
        if (times == 0) {
          widget.endCountDown();
          cancelTimer();
        }
      } else {
        cancelTimer();
      }
    });
  }

  cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  String CountDownTime(int seconds) {
    int days = (seconds / (3600 * 24)).toInt();
    int retain = seconds - days * (3600 * 24);
    int hours = (retain / 3600).toInt();
    retain = retain - hours * 3600;
    int minutes = (retain / 60).toInt();
    retain = retain - minutes * 60;
    bool showDay = days != 0;
    bool showHours = showDay || (hours != 0);
    bool showMinutes = showHours || (minutes != 0);
    return (showDay ? "$days" + "Days".tr() + " " : "") +
        (showHours ? "$hours" + "Hours".tr() + " " : "") +
        (showMinutes ? "$minutes" + "Minutes".tr() + " " : "") +
        "$retain" +
        "Seconds".tr();
  }
}
