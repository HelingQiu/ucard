
import 'package:flutter/material.dart';
import '../../../../../Common/BaseRouter.dart';
import '../Builder/MessageBuilder.dart';
class MessageRouter extends BaseRouter {

  //消息详情
  showMessageDetailScene(BuildContext context,int messageId) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MessageDetailBuilder(messageId).scene));
  }

}