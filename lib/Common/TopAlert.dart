import 'package:flutter/material.dart';

import '../gen_a/A.dart';

class TopAlert {
  OverlayEntry? overlayEntry;
  late Function() pressCallback;

  showTopAlert(
      BuildContext context, String title, String content, Function() callback) {
    overlayEntry = createOverlayEntry(title, content);
    pressCallback = callback;
    // pressCallback = callBack;
    Overlay.of(context)?.insert(overlayEntry!);

    Future.delayed(Duration(seconds: 9)).then((value) {
      overlayEntry?.remove();
    });
  }

  OverlayEntry createOverlayEntry(String title, String content) {
    overlayEntry = OverlayEntry(builder: (context) {
      return TopAlertOverlay(title, content, pressCallback);
    });
    return overlayEntry!;
  }
}

class TopAlertOverlay extends StatefulWidget {
  String title;
  String content;
  Function() pressCallback;

  TopAlertOverlay(this.title, this.content, this.pressCallback);

  @override
  TopAlertOverlayState createState() => TopAlertOverlayState();
}

class TopAlertOverlayState extends State<TopAlertOverlay>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool reversed = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();

    Future.delayed(Duration(seconds: 6)).then((value) {
      if (reversed == false) {
        reversed = true;
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Positioned(
        left: 15,
        right: 15,
        top: 120 * _animation.value - 120,
        child: Container(
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                color: Color.fromRGBO(200, 0, 0, 0).withOpacity(0),
                height: 70,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(128, 170, 255, 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      widget.pressCallback();
                      if (reversed == false) {
                        reversed = true;
                        _animationController.reverse();
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 30,
                              height: 30,
                              child: Image.asset(A.assets_icon1024x1024),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width - 105,
                              child: Text(
                                widget.title,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            Container(
                              width: width - 100,
                              // width: 280,
                              child: Text(
                                widget.content,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
