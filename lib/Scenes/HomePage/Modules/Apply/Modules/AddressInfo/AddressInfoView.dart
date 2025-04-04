import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
import 'package:pinput/pinput.dart';
import 'package:ucardtemp/Scenes/HomePage/Modules/Apply/Modules/AddressInfo/AddressSingleton.dart';

import '../../../../../../Common/ColorUtil.dart';
import '../../../../../../Common/ShowMessage.dart';
import '../../../../../../Common/TextImageButton.dart';
import '../../../../../../Data/AppStatus.dart';
import '../../../../../../gen_a/A.dart';
import '../../../../../../main.dart';
import '../AmericanState/Builder/AmericanStateBuilder.dart';
import '../ApplyUserInfo/CustomFormatter.dart';
import 'AddressInfoPresenter.dart';

class AddressInfoView extends StatelessWidget {
  final AddressInfoPresenter presenter;

  AddressInfoView(this.presenter);

  StreamController<int> streamController = StreamController.broadcast();
  ScrollController _scrollController = ScrollController();

  final TextEditingController _firstNameController =
      TextEditingController(text: '');
  final TextEditingController _lastNameController =
      TextEditingController(text: '');
  final TextEditingController _countryRegionController =
      TextEditingController(text: '');
  final TextEditingController _address1Controller =
      TextEditingController(text: '');
  final TextEditingController _address2Controller =
      TextEditingController(text: '');
  final TextEditingController _stateController =
      TextEditingController(text: '');
  final TextEditingController _cityController = TextEditingController(text: '');
  final TextEditingController _postCodeController =
      TextEditingController(text: '');

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
      var title = "";
      if (presenter.type == 0) {
        title = "Shipping To".tr();
      } else if (presenter.type == 1) {
        title = "Mailing Address".tr();
      } else {
        title = "Residential Address".tr();
      }
      return PageLifecycle(
        stateChanged: (appear) {
          if (appear) {
            streamController.add(0);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor),
            ),
            backgroundColor: theme == AppTheme.light
                ? AppStatus.shared.bgWhiteColor
                : AppStatus.shared.bgBlackColor,
          ),
          backgroundColor: theme == AppTheme.light
              ? AppStatus.shared.bgWhiteColor
              : AppStatus.shared.bgBlackColor,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _scrollController.animateTo(0,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            child: StreamBuilder<int>(
              stream: streamController.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Container(
                  color: theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : AppStatus.shared.bgBlackColor,
                  height: MediaQuery.of(context).size.height,
                  child: SafeArea(
                      child: Stack(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            _buildeNameInfoView(context),
                            _buildNameView(context),
                            // EmailView(context),
                            // PhoneView(context),
                            // _buildeAddressView(context),
                            // _buildHouseNumberView(context),

                            _buildCityRegionView(context),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 10),
                              child: Text(
                                'Address'.tr(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: _theme == AppTheme.light
                                        ? AppStatus.shared.bgBlackColor
                                        : AppStatus.shared.bgWhiteColor),
                              ),
                            ),
                            _buildAddress1View(context),
                            _buildAddress2View(context),
                            _buildStateView(context),
                            _buildCityView(context),
                            _buildPostCodeView(context),
                            SizedBox(
                              height: 400,
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        child: Container(
                            height: 114,
                            color: theme == AppTheme.light
                                ? AppStatus.shared.bgWhiteColor
                                : AppStatus.shared.bgBlackColor,
                            child: _buildSubmitButton(context)),
                        bottom: 0,
                        height: 114,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  )),
                );
              },
            ),
          ),
        ),
      );
    });
  }

  Widget _buildeNameInfoView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 20, right: 16),
      child: Container(
        // child: TextImageButton(
        //   margin: 4,
        // type: TextIconButtonType.imageRight,
        // icon: InkWell(
        //     onTap: () {
        //       showAddressAlertDialog(context, "Name".tr(), "Name note".tr());
        //     },
        //     child: Image.asset(_theme == AppTheme.light
        //         ? A.assets_question_black
        //         : A.assets_reward_info)),
        child: Text(
          'Name'.tr(),
          style: TextStyle(
              fontSize: 15,
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor),
        ),
        // onTap: () {},
        // ),
      ),
    );
  }

  Widget _buildNameView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgGreyLightColor
                    : AppStatus.shared.bgGreyColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                textAlign: TextAlign.start,
                autocorrect: false,
                controller: _firstNameController,
                textAlignVertical: TextAlignVertical.center,
                maxLines: 1,
                style: TextStyle(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgBlackColor
                        : AppStatus.shared.bgWhiteColor,
                    fontSize: 16),
                inputFormatters: [
                  CustomFormatter(),
                ],
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    border: InputBorder.none,
                    hintText: "First name".tr(),
                    hintStyle: TextStyle(
                        color: AppStatus.shared.textGreyColor, fontSize: 14)),
                onChanged: (text) {
                  //
                },
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgGreyLightColor
                    : AppStatus.shared.bgGreyColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                textAlign: TextAlign.start,
                autocorrect: false,
                controller: _lastNameController,
                textAlignVertical: TextAlignVertical.center,
                maxLines: 1,
                style: TextStyle(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgBlackColor
                        : AppStatus.shared.bgWhiteColor,
                    fontSize: 16),
                inputFormatters: [
                  CustomFormatter(),
                ],
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 15, right: 15, bottom: 15),
                    border: InputBorder.none,
                    hintText: "Last name".tr(),
                    hintStyle: TextStyle(
                        color: AppStatus.shared.textGreyColor, fontSize: 14)),
                onChanged: (text) {
                  //
                },
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityRegionView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Country/Region'.tr(),
            style: TextStyle(
                fontSize: 15,
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => AmericanStateBuilder(true).scene))
                  .then((value) {
                debugPrint(
                    "=======${AppStatus.shared.countryModel.countryname}");
                _countryRegionController
                    .setText(AppStatus.shared.countryModel.countryname);
                streamController.add(0);
              });
            },
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgGreyLightColor
                    : AppStatus.shared.bgGreyColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                textAlign: TextAlign.start,
                autocorrect: false,
                controller: _countryRegionController,
                textAlignVertical: TextAlignVertical.center,
                enabled: false,
                style: TextStyle(
                    color: _theme == AppTheme.light
                        ? AppStatus.shared.bgBlackColor
                        : AppStatus.shared.bgWhiteColor,
                    fontSize: 16),
                inputFormatters: [
                  CustomFormatter(),
                ],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 15,
                    right: 5,
                    bottom: 1,
                  ),
                  border: InputBorder.none,
                  hintText: "Country/Region".tr(),
                  hintStyle: TextStyle(
                      color: AppStatus.shared.textGreyColor, fontSize: 14),
                  suffixIcon: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 52),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.asset(_theme == AppTheme.light
                            ? A.assets_apply_down_black
                            : A.assets_home_apply_down),
                      )),
                ),
                onChanged: (text) {
                  //
                },
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                  // _scrollController.animateTo(0,
                  //     duration: Duration(milliseconds: 500), curve: Curves.ease);
                },
                onTap: () {
                  // _scrollController.animateTo(220,
                  //     duration: Duration(milliseconds: 500), curve: Curves.ease);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddress1View(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgGreyLightColor
              : AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          textAlign: TextAlign.start,
          autocorrect: false,
          controller: _address1Controller,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor,
              fontSize: 16),
          // keyboardType: TextInputType.number,
          inputFormatters: [
            // FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              border: InputBorder.none,
              hintText: "Address Line 1".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14)),
          onChanged: (text) {
            //
          },
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            // _scrollController.animateTo(0,
            //     duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          onTap: () {
            // _scrollController.animateTo(220,
            //     duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ),
      ),
    );
  }

  Widget _buildAddress2View(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgGreyLightColor
              : AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          textAlign: TextAlign.start,
          autocorrect: false,
          controller: _address2Controller,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor,
              fontSize: 16),
          // keyboardType: TextInputType.number,
          inputFormatters: [
            // FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              border: InputBorder.none,
              hintText: "Address Line 2".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14)),
          onChanged: (text) {
            //
          },
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            // _scrollController.animateTo(0,
            //     duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          onTap: () {
            // _scrollController.animateTo(220,
            //     duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ),
      ),
    );
  }

  Widget _buildStateView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: InkWell(
        onTap: () {
          //跳转洲选择
          // Navigator.of(context)
          //     .push(MaterialPageRoute(
          //         builder: (context) => AmericanStateBuilder().scene))
          //     .then((value) {
          //   debugPrint("=======${AppStatus.shared.stateModel.title}");
          //   _stateController.setText(AppStatus.shared.stateModel.title);
          //   streamController.add(0);
          // });
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: _theme == AppTheme.light
                ? AppStatus.shared.bgGreyLightColor
                : AppStatus.shared.bgGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            textAlign: TextAlign.start,
            autocorrect: false,
            controller: _stateController,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontSize: 16),
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 15),
                border: InputBorder.none,
                hintText: "Province/ State".tr(),
                hintStyle: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 14)),
            onChanged: (text) {
              //
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              _scrollController.animateTo(0,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            onTap: () {
              _scrollController.animateTo(220,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCityView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: InkWell(
        onTap: () {
          //跳转洲选择
          // Navigator.of(context)
          //     .push(MaterialPageRoute(
          //         builder: (context) => AmericanStateBuilder().scene))
          //     .then((value) {
          //   debugPrint("=======${AppStatus.shared.stateModel.title}");
          //   _cityController.setText(AppStatus.shared.stateModel.title);
          //   streamController.add(0);
          // });
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: _theme == AppTheme.light
                ? AppStatus.shared.bgGreyLightColor
                : AppStatus.shared.bgGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            textAlign: TextAlign.start,
            autocorrect: false,
            controller: _cityController,
            textAlignVertical: TextAlignVertical.center,
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontSize: 16),
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 15),
                border: InputBorder.none,
                hintText: "City".tr(),
                hintStyle: TextStyle(
                    color: AppStatus.shared.textGreyColor, fontSize: 14)),
            onChanged: (text) {
              //
            },
            onEditingComplete: () {
              FocusScope.of(context).unfocus();
              _scrollController.animateTo(0,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            onTap: () {
              _scrollController.animateTo(220,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPostCodeView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgGreyLightColor
              : AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          textAlign: TextAlign.start,
          autocorrect: false,
          controller: _postCodeController,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor,
              fontSize: 16),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              border: InputBorder.none,
              hintText: "Zip code".tr(),
              hintStyle: TextStyle(
                  color: AppStatus.shared.textGreyColor, fontSize: 14)),
          onChanged: (text) {
            //
          },
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
            _scrollController.animateTo(0,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          onTap: () {
            _scrollController.animateTo(220,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
        ),
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                presenter.cancelPressed(context);
              },
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xff232323),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    "Cancel".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                saveInfo(context);
              },
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppStatus.shared.bgBlueColor,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Center(
                  child: Text(
                    "Save".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  saveInfo(BuildContext context) async {
    var firstName = _firstNameController.text;
    var lastName = _lastNameController.text;
    var countryName = _countryRegionController.text;
    var line_1 = _address1Controller.text;
    var line_2 = _address2Controller.text;
    var province = _stateController.text;
    var city = _cityController.text;
    var zipcode = _postCodeController.text;

    String error = "";
    if (firstName.isEmpty) {
      error = "Please enter firstName".tr();
    } else if (lastName.isEmpty) {
      error = "Please enter lastName".tr();
    } else if (countryName.isEmpty) {
      error = "Please enter Country/Region".tr();
    } else if (line_1.isEmpty) {
      error = "Please enter address line 1".tr();
    } else if (line_2.isEmpty) {
      error = "Please enter address line 2".tr();
    } else if (province.isEmpty) {
      error = "Please select Province/State".tr();
    } else if (city.isEmpty) {
      error = "Please select city".tr();
    } else if (zipcode.isEmpty) {
      error = "Please enter zip code".tr();
    }
    if (error.isNotEmpty) {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(2, error, styleType: 1, width: 257);
          });
      return;
    }
    //提交
    var addressInfo = {
      "first_name": firstName,
      "last_name": lastName,
      "country_name": countryName,
      "line_1": line_1,
      "line_2": line_2,
      "province": province,
      "city": city,
      "zip_code": zipcode,
      "country_region": AppStatus.shared.countryModel.code,
    };
    if (presenter.type == 0) {
      AddressSingleton.shared.shippingDict = addressInfo;
    } else if (presenter.type == 1) {
      AddressSingleton.shared.mailingDict = addressInfo;
    } else {
      AddressSingleton.shared.residentialDict = addressInfo;
    }
    presenter.savePressed(context);
  }

  showAddressAlertDialog(BuildContext context, String title, String content) {
    String buttonTitle = "OK".tr();
    showDialog(
      context: context,
      builder: (_) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: Container(
            // height: height,
            width: MediaQuery.of(context).size.width - 88,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : ColorsUtil.hexColor(0x252525),
                ),
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      content,
                      style: TextStyle(
                        fontSize: 14,
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 44,
                        width: MediaQuery.of(context).size.width - 88 - 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: AppStatus.shared.bgBlueColor,
                        ),
                        child: Center(
                          child: Text(
                            buttonTitle,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
