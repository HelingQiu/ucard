import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';

import '../../../../../Data/AppStatus.dart';
import '../Entity/MessageModel.dart';
import '../Presenter/MessagePresenter.dart';

class MessageDetailView extends StatelessWidget {
  final MessageDetailPresenter presenter;
  MessageModel model =
      MessageModel(0, 0, 0, DateTime.now(), DateTime.now(), '', '', '');
  MessageDetailView(this.presenter, {Key? key}) : super(key: key);
  StreamController<int> messageDetailController = StreamController();

  @override
  Widget build(BuildContext context) {
    String updateTime =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(model.updated_at);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notification".tr(),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
        ),
        elevation: 0,
        backgroundColor: AppStatus.shared.bgBlackColor,
      ),
      backgroundColor: AppStatus.shared.bgBlackColor,
      body: StreamBuilder<int>(
          stream: messageDetailController.stream,
          builder: (context, snapshot) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),

              padding: EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 28,
                ),
                Text(
                  model.title,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  updateTime,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12, color: AppStatus.shared.textGreyColor),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  model.content,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            );
          }),
    );
  }

  void updateContent(MessageModel item) {
    model = item;
    messageDetailController.add(0);
  }
}
