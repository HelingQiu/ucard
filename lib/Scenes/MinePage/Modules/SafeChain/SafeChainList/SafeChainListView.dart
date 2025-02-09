import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Scenes/MinePage/Modules/SafeChain/SafeChainList/WhiteListModel.dart';

import '../../../../../Data/AppStatus.dart';
import '../../../../../gen_a/A.dart';
import '../../../../../main.dart';
import 'SafeChainListPresenter.dart';

class SafeChainListView extends StatelessWidget {
  final SafeChainListPresenter presenter;

  SafeChainListView(this.presenter);

  StreamController<int> controller = StreamController.broadcast();

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
          centerTitle: false,
          toolbarHeight: 40,
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          title: Text(
            'Safe Chain'.tr(),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
        ),
        backgroundColor: theme == AppTheme.light
            ? AppStatus.shared.bgWhiteColor
            : AppStatus.shared.bgBlackColor,
        body: StreamBuilder<int>(
          stream: controller.stream,
          builder: (context, snapshot) {
            return Container(
              color: theme == AppTheme.light
                  ? AppStatus.shared.bgWhiteColor
                  : AppStatus.shared.bgBlackColor,
              child: SafeArea(
                child: Column(
                  children: [
                    _buildNodataView(context),
                    _buildChainListDataView(context),
                    Expanded(
                        child: Column(
                      children: [Spacer(), CancellationButton(context)],
                    )),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildChainListDataView(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: presenter.chainList.length,
        itemBuilder: (context, index) {
          WhiteListModel model = presenter.chainList[index];
          return Container(
            constraints: BoxConstraints(minHeight: 44),
            margin:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppStatus.shared.bgBlueColor),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  "${model.agreement}:${model.address}",
                  style: TextStyle(
                      color: _theme == AppTheme.light
                          ? AppStatus.shared.bgBlackColor
                          : AppStatus.shared.bgWhiteColor,
                      fontSize: 16),
                ),
              ),
            ),
          );
        });
  }

  Widget CancellationButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        presenter.addButtonPressed(context);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 50, left: 16, right: 16),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppStatus.shared.bgBlueColor,
            borderRadius: BorderRadius.circular(22),
          ),
          height: 44,
          child: Center(
            child: Text(
              "Add".tr(),
              style:
                  TextStyle(color: AppStatus.shared.bgWhiteColor, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNodataView(BuildContext context) {
    return Visibility(
      visible: presenter.chainList.isEmpty,
      child: Container(
        height: MediaQuery.of(context).size.height - 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(A.assets_ucard_nodata),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "No data  ".tr(),
                style: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
