import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/AppStatus.dart';
import '../Entity/MessageModel.dart';
import '../Interactor/MessageInteractor.dart';
import '../Router/MessageRouter.dart';
import '../View/MessageDetailView.dart';
import '../View/MessageView.dart';

class MessagePresenter {
  final MessageInteractor interactor;
  MessageView? view;
  final MessageRouter router;
  int page = 0;
  int pageSize = 10;
  int status = 1; //1,可用。 2,失效
  int type = 1; // 1,用户中心优惠券 2，我的优惠券
  bool hasMore = true;
  bool isFetching = false;
  bool isBeforeFetch = true;

  List<MessageModel> Messages = [];

  MessagePresenter(this.interactor, this.router) {
    fetchMessageList();
  }

  Future<void> fetchMessages() async {
    isFetching = true;
    page = 1;
    pageSize = 10;
    hasMore = true;
    Messages.clear();
    fetchMessageList();
  }

  Future<bool> fetchMoreMessages() async {
    if (isFetching) {
      await Future.delayed(Duration(milliseconds: 2000), () {});
    }
    isFetching = true;
    page = page + 1;
    fetchMessageList();
    return true;
  }

  fetchMessageList() async {
    MessageModel m = MessageModel(
        0, 1, 1, DateTime.now(), DateTime.now(), '123', 'Reminder', '345');
    // Messages.add(m);
    // Messages.add(m);
    // Messages.add(m);
    // Messages.add(m);
    // Messages.add(m);
    var dic = await interactor.fetchMessageList(
        page, pageSize, AppStatus.shared.lang);
    isBeforeFetch = false;
    if (page == 1) {
      Messages.clear();
    }
    if (dic != null) {
      List cs = dic["msgs"];
      cs.forEach((element) {
        MessageModel model = MessageModel.parse(element);
        Messages.add(model);
      });

      isFetching = false;
      if (cs.length < pageSize) {
        hasMore = false;
      } else {
        hasMore = true;
      }
    }
    view?.updateMessageList(Messages);
  }

  markAllRead(BuildContext context, Map<String, dynamic> parameter) async {
    var result = await interactor.markReadMessage(parameter);

    Navigator.of(context).pop();

    if (result[0] == 1) {
      fetchMessages();
      showDialog(
          context: context,
          builder: (_) {
            // return ShowMessage(result[0], "all read".tr());
            return ShowMessage(result[0], "Read All".tr(),
                styleType: 1, width: 257);
          });
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(result[0], result[1], styleType: 1, width: 257);
            // return ShowMessage(result[0], result[1]);
          });
    }
  }

  markRead(BuildContext context, Map<String, dynamic> parameter) async {
    var result = await interactor.markReadMessage(parameter);

    if (result[0] == 1) {
      fetchMessages();
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(result[0], result[1], styleType: 1, width: 257);
          });
    }
  }

  clearAllMessages(BuildContext context) async {
    var result = await interactor.clearAllMessages();

    //这里放在哪里顺序很重要 （要放在请求后面）
    Navigator.of(context).pop();

    if (result[0] == 1) {
      //删除成功后直接清空
      Messages.clear();
      view?.updateMessageList(Messages);

      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(result[0], "clear successfully".tr(),
                styleType: 1, width: 257);
            // return ShowMessage(result[0], "clear successfully".tr());
          });
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(result[0], result[1], styleType: 1, width: 257);
            // return ShowMessage(result[0], result[1]);
          });
    }
  }

  showMessageDetail(BuildContext context, MessageModel model) {
    router.showMessageDetailScene(context, model.messageId);
  }
}

class MessageDetailPresenter {
  final MessageInteractor interactor;
  MessageDetailView? view;
  final MessageRouter router;
  MessageDetailPresenter(this.interactor, this.router, int messageId) {
    //
    getDetailInfo(messageId);
  }

  void getDetailInfo(int messageId) async {
    var model = await interactor.fetchMessageInfo(messageId);
    if (model != null) {
      view?.updateContent(model);
    }
  }
}
