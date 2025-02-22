import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_page_lifecycle/flutter_page_lifecycle.dart';
import 'package:pinput/pinput.dart';

import '../../../../../../Common/ColorUtil.dart';
import '../../../../../../Common/NumberPlus.dart';
import '../../../../../../Common/ShowMessage.dart';
import '../../../../../../Common/TextImageButton.dart';
import '../../../../../../Data/AppStatus.dart';
import '../../../../../../Data/UserInfo.dart';
import '../../../../../../gen_a/A.dart';
import '../../../../../../main.dart';
import '../../../../../MinePage/Modules/AccountSecurity/BindEmail/BindEmailBuilder.dart';
import '../../../../../MinePage/Modules/AccountSecurity/BindPhone/BindPhoneBuilder.dart';
import '../../../../../MinePage/Modules/AccountSecurity/UpdateEmail/UpdateEmailBuilder.dart';
import '../../../../../MinePage/Modules/AccountSecurity/UpdatePhone/UpdatePhoneBuilder.dart';
import '../../Builder/ApplyBuilder.dart';
import '../AmericanState/Builder/AmericanStateBuilder.dart';
import 'ApplyUserInfoPresenter.dart';
import 'CustomFormatter.dart';

class ApplyUserInfoView extends StatelessWidget {
  final ApplyUserInfoPresenter presenter;

  StreamController<int> streamController = StreamController.broadcast();
  ScrollController _scrollController = ScrollController();

  final TextEditingController _firstNameController =
      TextEditingController(text: '');
  final TextEditingController _lastNameController =
      TextEditingController(text: '');
  final TextEditingController _houseNumController =
      TextEditingController(text: '');
  final TextEditingController _cityRegionController =
      TextEditingController(text: '');
  final TextEditingController _stateController =
      TextEditingController(text: '');
  final TextEditingController _postCodeController =
      TextEditingController(text: '');

  ApplyUserInfoView(this.presenter);

  AppTheme _theme = AppTheme.dark;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ThemeCubit, AppTheme>(builder: (context, theme) {
      _theme = theme;
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
              "Apply".tr(),
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
                            EmailView(context),
                            PhoneView(context),
                            _buildeAddressView(context),
                            _buildHouseNumberView(context),
                            _buildCityRegionView(context),
                            _buildStateView(context),
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
        child: TextImageButton(
          margin: 4,
          type: TextIconButtonType.imageRight,
          icon: InkWell(
              onTap: () {
                showAddressAlertDialog(context, "Name".tr(), "Name note".tr());
              },
              child: Image.asset(_theme == AppTheme.light
                  ? A.assets_question_black
                  : A.assets_reward_info)),
          text: Text(
            'Name'.tr(),
            style: TextStyle(
                fontSize: 15,
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
          onTap: () {},
        ),
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
                    hintText: "First name",
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
                    hintText: "Last name",
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

  Widget EmailView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 20),
      child: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Email2".tr(),
                    style: TextStyle(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontSize: 14),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      toBindUpdateEmail(context);
                    },
                    child: Text(
                      (UserInfo.shared.email != "")
                          ? NumberPlus.getSecurityEmail(UserInfo.shared.email)
                          : "To be connected".tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppStatus.shared.textGreyColor, fontSize: 14),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    toBindUpdateEmail(context);
                  },
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  toBindUpdateEmail(BuildContext context) {
    if (UserInfo.shared.email != "" && UserInfo.shared.phone != "") {
      //跳转到修改邮箱
      showUpdateEmailPhoneDiolog(context, 0);
    } else if (UserInfo.shared.email != "" && UserInfo.shared.phone == "") {
      showAlertDialog(context);
    } else {
      //跳转到绑定邮箱
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BindEmailBuilder('').scene));
    }
  }

  Widget PhoneView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Phone number2".tr(),
                    style: TextStyle(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        fontSize: 14),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      toBindUpdatePhone(context);
                    },
                    child: Text(
                      (UserInfo.shared.phone != "")
                          ? "+" +
                              NumberPlus.getSecurityEmail(UserInfo.shared.phone)
                          : "To be connected".tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: AppStatus.shared.textGreyColor, fontSize: 14),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    toBindUpdatePhone(context);
                  },
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  toBindUpdatePhone(BuildContext context) {
    if (UserInfo.shared.phone != "" && UserInfo.shared.email != "") {
      //跳转到修改手机
      showUpdateEmailPhoneDiolog(context, 1);
    } else if (UserInfo.shared.phone != "" && UserInfo.shared.email == "") {
      showAlertDialog(context);
    } else {
      //跳转到绑定手机
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BindPhoneBuilder('').scene));
    }
  }

  Widget _buildeAddressView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, top: 20, right: 16),
      child: Container(
        child: TextImageButton(
          margin: 4,
          type: TextIconButtonType.imageRight,
          icon: InkWell(
              onTap: () {
                showAddressAlertDialog(
                    context, "Address(USA Only)".tr(), "Address note".tr());
              },
              child: Image.asset(_theme == AppTheme.light
                  ? A.assets_question_black
                  : A.assets_reward_info)),
          text: Text(
            'Address(USA Only)'.tr(),
            style: TextStyle(
                fontSize: 15,
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor),
          ),
          onTap: () {},
        ),
      ),
    );
  }

  //输入内容
  Widget _buildHouseNumberView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 20),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: _theme == AppTheme.light
              ? AppStatus.shared.bgGreyLightColor
              : AppStatus.shared.bgGreyColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          textAlign: TextAlign.start,
          autocorrect: false,
          controller: _houseNumController,
          textAlignVertical: TextAlignVertical.center,
          maxLines: 5,
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
                  EdgeInsets.only(left: 15, right: 15, bottom: 12, top: 12),
              border: InputBorder.none,
              hintText: "Street address",
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

  Widget _buildCityRegionView(BuildContext context) {
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
          controller: _cityRegionController,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
              color: _theme == AppTheme.light
                  ? AppStatus.shared.bgBlackColor
                  : AppStatus.shared.bgWhiteColor,
              fontSize: 16),
          inputFormatters: [
            CustomFormatter(),
          ],
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
              border: InputBorder.none,
              hintText: "City/region",
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

  Widget _buildStateView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
      child: InkWell(
        onTap: () {
          //跳转洲选择
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => AmericanStateBuilder(false).scene))
              .then((value) {
            debugPrint("=======${AppStatus.shared.stateModel.title}");
            _stateController.setText(AppStatus.shared.stateModel.title);
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
            controller: _stateController,
            textAlignVertical: TextAlignVertical.center,
            enabled: false,
            style: TextStyle(
                color: _theme == AppTheme.light
                    ? AppStatus.shared.bgBlackColor
                    : AppStatus.shared.bgWhiteColor,
                fontSize: 16),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.only(
                  left: 15,
                  right: 5,
                  bottom: 1,
                ),
                suffixIcon: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 52),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Image.asset(_theme == AppTheme.light
                          ? A.assets_apply_down_black
                          : A.assets_home_apply_down),
                    )),
                border: InputBorder.none,
                hintText: "State",
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
              hintText: "Zip code",
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

  //下一步
  Widget _buildSubmitButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 50, top: 20),
      child: InkWell(
        onTap: () {
          //
          FocusScope.of(context).unfocus();
          submitApplyInfo(context);
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
              "Next".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }

  //提交数据
  submitApplyInfo(BuildContext context) async {
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String email = UserInfo.shared.email;
    String phone = UserInfo.shared.phone;
    String address = _houseNumController.text;
    String city = _cityRegionController.text;
    String state =
        _stateController.text.isNotEmpty ? AppStatus.shared.stateModel.jx : "";
    String zipcode = _postCodeController.text;

    String error = "";
    if (firstName.isEmpty) {
      error = "Please enter firstName".tr();
    } else if (lastName.isEmpty) {
      error = "Please enter lastName".tr();
    } else if (email.isEmpty || phone.isEmpty) {
      error = "Please bind mobile phone/email first".tr();
    } else if (address.isEmpty) {
      error = "Please enter address".tr();
    } else if (city.isEmpty) {
      error = "Please enter city/region".tr();
    } else if (state.isEmpty) {
      error = "Please select state".tr();
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
    var result = await presenter.requestApplyCardUser(
        firstName, lastName, state, city, address, zipcode);
    if (context.mounted) {
      if (result[0] == 1) {
        //下一步
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ApplyBuilder(presenter.card).scene));
      } else {
        showDialog(
            context: context,
            builder: (_) {
              return ShowMessage(2, result[1], styleType: 1, width: 257);
            });
      }
    }
  }

  //提示绑定
  showAlertDialog(BuildContext context) {
    String str1 = "Please bind mobile phone/email first".tr();

    String buttonTitle = "OK".tr();

    showDialog(
      context: context,
      builder: (_) {
        return UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          child: SizedBox(
            width: 287,
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : ColorsUtil.hexColor(0x252525),
                ),
                // margin:EdgeInsetsDirectional.only(top: 39) ,
                padding: EdgeInsets.only(top: 34, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      str1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgBlackColor
                            : AppStatus.shared.bgWhiteColor,
                        // decoration: TextDecoration.none
                      ),
                    ),
                    SizedBox(
                      height: 47,
                    ),
                    Container(
                      width: 247,
                      height: 44,
                      child: ElevatedButton(
                        child: SizedBox(
                          child: Text(
                            buttonTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppStatus.shared.bgBlueColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
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

  ///是否确认更新邮箱 ///是否确认更新手机号 0-email 1-phone
  showUpdateEmailPhoneDiolog(BuildContext context, int type) {
    var title = '';
    var content = '';
    if (type == 0) {
      title = 'Confirm to update your email address?';
      content = 'Confirm update address note';
    } else {
      title = 'Confirm to update your phone number?';
      content = "Confirm update phone note";
    }
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(maxHeight: 234),
        builder: (BuildContext context2) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            return Container(
              decoration: BoxDecoration(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgWhiteColor
                      : ColorsUtil.hexColor(0x2E2E2E),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child:
                  _buildEmailPhoneDialogContent(context, type, title, content),
            );
          });
        }).whenComplete(() {});
  }

  Widget _buildEmailPhoneDialogContent(
      BuildContext context, int type, String title, String content) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              title.tr(),
              style: TextStyle(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Text(
              content.tr(),
              style: TextStyle(
                  color: _theme == AppTheme.light
                      ? AppStatus.shared.bgBlackColor
                      : AppStatus.shared.bgWhiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
                  child: InkWell(
                    onTap: () {
                      //取消
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 44,
                      width: 100,
                      decoration: BoxDecoration(
                        color: _theme == AppTheme.light
                            ? AppStatus.shared.bgGreyLightColor
                            : AppStatus.shared.bgDarkGreyColor,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel".tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: _theme == AppTheme.light
                                  ? AppStatus.shared.bgBlackColor
                                  : AppStatus.shared.bgWhiteColor,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20, top: 10),
                  child: InkWell(
                    onTap: () {
                      //确认
                      Navigator.pop(context);
                      if (type == 0) {
                        //更新邮箱
                        if (UserInfo.shared.phone != "" &&
                            UserInfo.shared.email != "") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UpdateEmailBuilder().scene));
                        } else {}
                      } else {
                        //更新手机号
                        if (UserInfo.shared.phone != "" &&
                            UserInfo.shared.email != "") {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  UpdatePhoneBuilder().scene));
                        } else {}
                      }
                    },
                    child: Container(
                      height: 44,
                      width: 100,
                      decoration: BoxDecoration(
                        color: AppStatus.shared.bgBlueColor,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: Text(
                          "Confirm".tr(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
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
