import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Data/AppStatus.dart';
import '../../../../main.dart';
import '../../Entity/MyawardsModel.dart';
import '../Presenter/ReferralsPresenter.dart';

class ReferralsView extends StatelessWidget {
  final ReferralsPresenter presenter;

  ReferralsView(this.presenter);
  StreamController<int> streamController = StreamController.broadcast();

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: theme == AppTheme.light
                ? AppStatus.shared.bgBlackColor
                : AppStatus.shared.bgWhiteColor, //修改颜色
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          title: Text(
            'Referrals'.tr(),
            style: TextStyle(
                fontSize: 18,
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
        ),
        body: StreamBuilder<int>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              return Container(
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgWhiteColor
                    : AppStatus.shared.bgBlackColor,
                child: ListView.builder(
                  itemCount: presenter.awardsList.length,
                  itemBuilder: (context, index) {
                    MyawardsModel model = presenter.awardsList[index];
                    return Container(
                      height: 60,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      color: theme == AppTheme.light
                          ? AppStatus.shared.bgWhiteColor
                          : AppStatus.shared.bgBlackColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Text(
                                  model.user_name,
                                  style: TextStyle(
                                      color: theme == AppTheme.light
                                          ? AppStatus.shared.bgBlackColor
                                          : AppStatus.shared.bgWhiteColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  model.created_at,
                                  style: TextStyle(
                                      color: AppStatus.shared.textGreyColor,
                                      fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          //右边
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${model.card_count} " + "Card".tr(),
                                style: TextStyle(
                                    color: theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : AppStatus.shared.bgWhiteColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
      );
    });
  }
}
