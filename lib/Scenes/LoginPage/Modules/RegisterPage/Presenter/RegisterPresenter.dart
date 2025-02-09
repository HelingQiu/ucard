import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucardtemp/Common/StringExtension.dart';
import 'package:ucardtemp/Data/LoginCenter.dart';

import '../../../../../Common/ShowMessage.dart';
import '../../../../../Data/AppStatus.dart';
import '../../../../../Data/UserInfo.dart';
import '../../../../../Network/Api.dart';
import '../Interactor/RegisterInteractor.dart';
import '../Router/RegisterRouter.dart';
import '../View/RegisterView.dart';

class RegisterPresenter {
  final RegisterInteractor interactor;
  RegisterView? view;
  final RegisterRouter router;
  bool agree = false;
  int registerMethod = 0;

  RegisterPresenter(this.interactor, this.router) {}

  loginButtonPressed(BuildContext context) {
    router.loginButtonPressed(context);
  }

  //next
  nextPressed(BuildContext context, String account, String smscode) {
    String registerErr = "";
    String registerAccount = account;
    if (smscode.isEmpty) {
      registerErr = "No Verification Code".tr();
    } else if (agree == false) {
      registerErr = "Must agree to the User Agreement".tr();
    } else {
      if (registerMethod == 0) {
        if (account.isEmpty) {
          registerErr = "No email".tr();
        } else if (account.isValidEmail() == false) {
          registerErr = "Wrong email".tr();
        }
      } else {
        if (UserInfo.shared.areaCode == null) {
          registerErr = "No area code".tr();
        } else if (account.isEmpty) {
          registerErr = "No phone number".tr();
        } else {
          registerAccount =
              "${UserInfo.shared.areaCode!.interarea.replaceAll("+", "")} $account";
        }
      }
    }
    if (registerErr.isNotEmpty) {
      showDialog(
          context: context,
          builder: (_) {
            return ShowMessage(0, registerErr, styleType: 1, width: 257);
          });
      return;
    }
    router.showCreatePsdScene(
        context, registerAccount, smscode, registerMethod == 0 ? 1 : 2);
  }

  bool agreeButtonPressed() {
    debugPrint("agreeButtonPressed");
    agree = !agree;
    return agree;
  }

  closeButtonPressed(BuildContext context) {
    router.popToRoot(context);
  }

  Future<bool> emailSendCodeButtonPressed(
      BuildContext context, String account) async {
    debugPrint("emailSendCodeButtonPressed");
    String registerErr = "";
    if (account.isEmpty) {
      registerErr = "No email".tr();
    } else if (account.isValidEmail() == false) {
      registerErr = "Wrong email".tr();
    }
    view?.registerErrorStreamController.add(registerErr);
    if (registerErr == "") {
      List result = await interactor.sendCode(account, 1, 1);
      int number = result[0];
      if (number != 0) {
        //success, remaintime
        // String message = result[1];
        // if (message.isNotEmpty) {
        //   showDialog(context: context, builder: (_) {
        //     return ShowMessage(0, message, styleType: 1, width: 257,);
        //   });
        // }
        return true;
      } else {
        String message = result[1];
        if (message.isNotEmpty) {
          showDialog(
              context: context,
              builder: (_) {
                return ShowMessage(
                  0,
                  message,
                  styleType: 1,
                  width: 257,
                );
              });
          view?.registerErrorStreamController.add(message);
        }
      }
    }
    return false;
  }

  Future<bool> phoneSendCodeButtonPressed(
      BuildContext context, String account) async {
    debugPrint("phoneSendCodeButtonPressed");
    String registerErr = "";
    if (account.isEmpty) {
      registerErr = "No phone number".tr();
    } else if (UserInfo.shared.areaCode == null) {
      registerErr = "No area code".tr();
    }
    view?.registerErrorStreamController.add(registerErr);
    if (registerErr == "") {
      List result = await interactor.sendCode(
          "${UserInfo.shared.areaCode!.interarea.replaceAll("+", "")} $account",
          1,
          2);
      int number = result[0];
      if (number != 0) {
        //success, remaintime
        // String message = result[1];
        // if (message.isNotEmpty) {
        //   showDialog(context: context, builder: (_) {
        //     return ShowMessage(0, message, styleType: 1, width: 257,);
        //   });
        // }
        return true;
      } else {
        String message = result[1];
        if (message.isNotEmpty) {
          showDialog(
              context: context,
              builder: (_) {
                return ShowMessage(
                  0,
                  message,
                  styleType: 1,
                  width: 257,
                );
              });
          view?.registerErrorStreamController.add(message);
        }
      }
    }
    return false;
  }

  successSendCode() async {
    print("successSendCode");
    await Future.delayed(Duration(seconds: 1));
    return false;
  }

  showError(String err) {
    view?.registerErrorStreamController.add(err);
  }

  areaCodeButtonPressed(BuildContext context) {
    router.showAreaCodeScene(context);
  }

  agreementButtonPressed(BuildContext context) {
    String registerAgreementUrl = Api().apiUrl +
        "/api/conf/agreementinfo?" +
        "code=a001&&lang=${AppStatus.shared.lang}";
    if (registerAgreementUrl != "") {
      router.showRegisterAgreementScene(context, registerAgreementUrl);
    }
  }
}

class RegisterMethodBloc extends Bloc<RegisterMethodState, int> {
  RegisterPresenter presenter;

  RegisterMethodBloc(this.presenter) : super(0) {
    on<EmailRegisterMethodState>((event, emit) {
      presenter.registerMethod = 0;
      debugPrint(
          'on<EmailLoginMethodState>  registerMethod = ${presenter.registerMethod}');
      emit(0);
    });
    on<PhoneRegisterMethodState>((event, emit) {
      presenter.registerMethod = 1;
      debugPrint(
          'on<PhoneRegisterMethodState>  registerMethod = ${presenter.registerMethod}');
      emit(1);
    });
  }
}

abstract class RegisterMethodState {}

class EmailRegisterMethodState extends RegisterMethodState {}

class PhoneRegisterMethodState extends RegisterMethodState {}

class RegisterAgreeBloc extends Bloc<RegisterAgreeState, bool> {
  RegisterPresenter presenter;

  RegisterAgreeBloc(this.presenter) : super(false) {
    on<RegisterAgreedState>((event, emit) {
      presenter.agree = true;
      debugPrint("presenter.agree = ${presenter.agree}");
      emit(true);
    });
    on<RegisterDisagreedState>((event, emit) {
      presenter.agree = false;
      debugPrint("presenter.agree = ${presenter.agree}");
      emit(false);
    });
  }
}

abstract class RegisterAgreeState {}

class RegisterAgreedState extends RegisterAgreeState {}

class RegisterDisagreedState extends RegisterAgreeState {}
