import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../Data/AppStatus.dart';
import '../Interactor/MainInteractor.dart';
import '../Router/MainRouter.dart';
import '../View/MainView.dart';

class MainPresenter {
  final MainInteractor interactor;
  final MainRouter router;
  MainView? view;
  bool gotUpdate = false;

  MainPresenter(this.interactor, this.router) {}

  fetchAppVersionNeedUpdate() async {
    Future.delayed(Duration(milliseconds: 5000), () {
      if (gotUpdate == false) {
        fetchAppVersionNeedUpdate();
      }
    });

    var data = await interactor.fetchAppVersionNeedUpdate();
    if (data != null && data is Map) {
      var code = data["status_code"];
      if (code != null) {
        if (code == 200) {
          gotUpdate = true;
          Map<String, dynamic> dic = data["data"];
          if (dic != null && dic is Map) {
            int update = 0;
            var ud = dic["update"];
            if (ud != null && ud is int) {
              update = ud;
            }

            Map newest = dic["newest"];
            if (newest != null) {
              String version = newest["version"] ?? "";
              AppStatus.shared.appstoreVersion = version;
              String title = newest["title"] ?? "";
              String content = newest["content"] ?? "";
              debugPrint("content = $content");
              String showContent = (title != "" ? title + "\n" : "") + content;
              AppStatus.shared.newVersionShowContent = showContent;
              debugPrint(
                  "update title = ${title} showContent = ${showContent}");
              if (update == 0) {
                return;
              }
              if (update == 2) {
                AppStatus.shared.canPopAd = false;
                view?.state.showAppVersionRemindView(2, showContent,
                    "The current version is not supported, please update".tr());
              } else {
                if (version != AppStatus.shared.remindedVersion) {
                  AppStatus.shared.remindedVersion = version;
                  AppStatus.shared.saveReminded();
                  AppStatus.shared.canPopAd = false;
                  view?.state.showAppVersionRemindView(1, showContent, "");
                }
              }
            }
          }
        }
      }
    }
  }

  showNotificationCenter(BuildContext context) {
    router.showNotificationCenter(context);
  }

  //消息详情
  showMessageDetail(BuildContext context, int messageId) {
    router.showMessageDetail(context, messageId);
  }
}
