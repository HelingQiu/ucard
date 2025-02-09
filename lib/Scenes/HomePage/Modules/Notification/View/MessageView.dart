import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loadmore/loadmore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import 'package:badges/badges.dart' as badges;

import '../../../../../Data/AppStatus.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import '../Entity/MessageModel.dart';
import '../Presenter/MessagePresenter.dart';

class MessageView extends StatelessWidget {
  final MessagePresenter presenter;
  List<MessageModel> data = [];
  StreamController<int> messageStreamController = StreamController();

  MessageView(this.presenter);

  bool isShow = true;

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor, //修改颜色
          ),
          title: Text(
            "Notification".tr(),
            style: TextStyle(
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontWeight: FontWeight.w500,
                fontSize: 18),
          ),
          elevation: 0,
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          actions: [
            TextButton(
                onPressed: () {
                  _showCustomModalBottomSheet(context);
                },
                child: Image.asset(theme == AppTheme.light
                    ? A.assets_more_icon_black
                    : A.assets_message_more_icon)),
          ],
        ),
        backgroundColor: theme == AppTheme.light
            ? AppStatus.shared.bgWhiteColor
            : AppStatus.shared.bgBlackColor,
        body: StreamBuilder<int>(
            stream: messageStreamController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return EasyRefresh(
                header: MaterialHeader(),
                footer: MaterialFooter(),
                onRefresh: () async {
                  await presenter.fetchMessages();
                },
                onLoad: () {
                  presenter.fetchMoreMessages();
                  if (!presenter.hasMore) {
                    return IndicatorResult.noMore;
                  }
                },
                child: ListView(
                  children: [
                    MessageListView(context),
                  ],
                ),
              );
            }),
      );
    });
  }

  Widget MessageListView(BuildContext context) {
    // debugPrint("coupons.length = ${presenter.coupons.length}");
    if (presenter.Messages.length == 0) {
      if (presenter.isBeforeFetch) {
        return Container();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 120,
          ),
          Container(
            width: double.infinity,
            height: 132,
            child: Image.asset(A.assets_ucard_nodata),
          ),
          Container(
            height: 40,
            child: Center(
              child: Text(
                "No data  ".tr(),
                style: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 12),
              ),
            ),
          )
        ],
      );
    }
    return Column(
      children: data.map((data) {
        return MessageContent(context, data);
      }).toList(),
    );
  }

  updateMessageList(List<MessageModel> models) {
    data = models;
    messageStreamController.add(0);
  }

  Widget MessageContent(BuildContext context, MessageModel model) {
    String updateTime = DateFormat("yyyy/MM/dd HH:mm").format(model.created_at);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (model.is_read == 0) {
          //只有消息未读时才去标记消息已读
          presenter.markRead(
              context, {"id": model.messageId, "lang": AppStatus.shared.lang});
        }
        presenter.showMessageDetail(context, model);
      },
      child: Container(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          height: 85,
          child: Stack(
            children: [
              Positioned(
                top: 13,
                left: 16,
                child: badges.Badge(
                    position: badges.BadgePosition.topEnd(top: 3, end: 3),
                    badgeContent: null,
                    // toAnimate: false,
                    showBadge: model.is_read == 0,
                    child: getHeadImage(model.type)),
              ),
              Positioned(
                  left: 68,
                  top: 14,
                  width: 170,
                  child: Text(
                    model.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 14,
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor),
                  )),
              Positioned(
                right: 43,
                top: 15,
                child: Text(
                  updateTime,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 14, color: AppStatus.shared.textGreyColor),
                ),
              ),
              Positioned(
                right: 16,
                top: 12,
                child: Image.asset(_theme == AppTheme.light
                    ? A.assets_notifi_right_black
                    : A.assets_notification_right),
              ),
              Positioned(
                left: 68,
                top: 42,
                right: 33,
                child: Text(
                  model.brief_content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 12,
                      color: _theme == AppTheme.light
                          ? AppStatus.shared.bgBlackColor
                          : AppStatus.shared.bgWhiteColor),
                ),
              ),
            ],
          )),
    );
  }

  Widget getHeadImage(int type) {
    if (type == 1 || type == 2) {
      //充值成功或者失败
      return Image.asset(
        _theme == AppTheme.light
            ? A.assets_notifi_withdraw_black
            : A.assets_notification_withdraw,
        fit: BoxFit.fitWidth,
      );
    } else if (type == 3 || type == 4) {
      //提现成功或者失败
      return Image.asset(
        _theme == AppTheme.light
            ? A.assets_notifi_deposit_black
            : A.assets_notification_deposit,
        fit: BoxFit.fitWidth,
      );
    } else if (type == 101) {
      //用户交易(消费)成功
      return Image.asset(
        _theme == AppTheme.light
            ? A.assets_notifi_consumption_black
            : A.assets_notification_consumption,
        fit: BoxFit.fitWidth,
      );
    } else if (type == 102) {
      //推荐奖励
      return Image.asset(
        _theme == AppTheme.light
            ? A.assets_notifi_reward_black
            : A.assets_notification_reward,
        fit: BoxFit.fitWidth,
      );
    } else {
      //其他的推送
      return Image.asset(
        _theme == AppTheme.light
            ? A.assets_notifi_reminder_black
            : A.assets_notification_reminder,
        fit: BoxFit.fitWidth,
      );
    }
  }

  _showCustomModalBottomSheet(context) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: 170),
      context: context,
      builder: (_) {
        return Container(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgDarkGreyColor,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: ElevatedButton(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 44,
                    child: Center(
                      child: Text(
                        "Read All".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStatus.shared.bgBlueColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () {
                    presenter.markAllRead(
                        context, {"all": 1, "lang": AppStatus.shared.lang});
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: ElevatedButton(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 44,
                    child: Center(
                      child: Text(
                        "Clear All".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: _theme == AppTheme.light
                                ? AppStatus.shared.bgBlackColor
                                : AppStatus.shared.bgWhiteColor,
                            fontSize: 14),
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: _theme == AppTheme.light
                        ? AppStatus.shared.bgGreyLightColor
                        : AppStatus.shared.bgDarkGreyColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () {
                    presenter.clearAllMessages(context);
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
