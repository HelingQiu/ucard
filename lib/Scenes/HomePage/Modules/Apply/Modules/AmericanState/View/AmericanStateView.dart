import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../Data/AppStatus.dart';
import '../../../../../../../main.dart';
import '../../../Entity/AmericanStateModel.dart';
import '../Presenter/AmericanStatePresenter.dart';

class AmericanStateView extends StatelessWidget {
  final AmericanStatePresenter presenter;
  StreamController<int> areaCodesStreamController = StreamController();
  final TextEditingController _searchController =
      TextEditingController(text: '');
  List<AmericanStateModel> areaCodes = [];
  List<CountryModel> countryDatas = [];

  AmericanStateView(this.presenter) {
    if (presenter.isCountryCode) {
      presenter.fetchCountryDatas();
    } else {
      presenter.fetchAreaCodes();
    }
  }

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            presenter.isCountryCode ? "Country".tr() : "State".tr(),
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
          elevation: 0,
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
        ),
        backgroundColor: theme == AppTheme.light
            ? AppStatus.shared.bgWhiteColor
            : AppStatus.shared.bgBlackColor,
        body: Container(
          child: StreamBuilder<int>(
            stream: areaCodesStreamController.stream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              debugPrint("areaCodes.length = ${areaCodes.length}");
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 15, right: 15, top: 20, bottom: 10),
                    child: Container(
                        height: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: theme == AppTheme.light
                                ? AppStatus.shared.bgGreyLightColor
                                : AppStatus.shared.bgGreyColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                              textAlign: TextAlign.start,
                              autocorrect: false,
                              controller: _searchController,
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                  color: theme == AppTheme.light
                                      ? AppStatus.shared.bgBlackColor
                                      : AppStatus.shared.bgWhiteColor),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : AppStatus.shared.bgWhiteColor,
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Search".tr(),
                                  hintStyle: TextStyle(
                                      color: AppStatus.shared.textGreyColor,
                                      fontSize: 14)),
                              onChanged: (text) {
                                if (presenter.isCountryCode) {
                                  presenter.countrySearchPressed(text);
                                } else {
                                  presenter.searchPressed(text);
                                }
                              },
                              onEditingComplete: () {
                                FocusScope.of(context).unfocus();
                              }),
                        )),
                  ),
                  Expanded(
                    child: Container(
                      child: ListView.builder(
                          itemCount: presenter.isCountryCode
                              ? countryDatas.length
                              : areaCodes.length,
                          itemBuilder: (context, index) {
                            var tempModel;
                            if (presenter.isCountryCode) {
                              CountryModel model = countryDatas[index];
                              tempModel = model;
                            } else {
                              AmericanStateModel model = areaCodes[index];
                              tempModel = model;
                            }

                            return Container(
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  if (presenter.isCountryCode) {
                                    presenter.countryPressed(
                                        context, tempModel);
                                  } else {
                                    presenter.areaPressed(context, tempModel);
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 16, right: 16, top: 14, bottom: 14),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${presenter.isCountryCode ? tempModel.countryname : tempModel.title}",
                                        style: TextStyle(
                                            color: theme == AppTheme.light
                                                ? AppStatus.shared.bgBlackColor
                                                : AppStatus.shared.bgWhiteColor,
                                            fontSize: 14),
                                      ),
                                      Spacer(),
                                      Text(
                                        "${presenter.isCountryCode ? tempModel.interarea : tempModel.jx}",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: theme == AppTheme.light
                                                ? AppStatus.shared.bgBlackColor
                                                : AppStatus.shared.bgWhiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      );
    });
  }

  updateContent(List<AmericanStateModel> codes) {
    areaCodes = codes;
    areaCodesStreamController.add(0);
  }

  updateCountryContent(List<CountryModel> results) {
    countryDatas = results;
    areaCodesStreamController.add(0);
  }
}
