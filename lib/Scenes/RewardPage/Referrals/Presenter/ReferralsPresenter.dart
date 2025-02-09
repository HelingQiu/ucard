import '../../Entity/MyawardsModel.dart';
import '../Interactor/ReferralsInteractor.dart';
import '../Router/ReferralsRouter.dart';
import '../View/ReferralsView.dart';

class ReferralsPresenter {
  final ReferralsInteractor interactor;
  ReferralsView? view;
  final ReferralsRouter router;
  ReferralsPresenter(this.interactor, this.router) {
    fetchMyreferralsList();
  }

  List<MyawardsModel> awardsList = [];

  //推荐人列表
  fetchMyreferralsList() async {
    var body = await interactor.fetchReferrals();
    if (body != null) {
      var list = body['list'];
      list.forEach((element) {
        if (element is Map<String, dynamic>) {
          var model = MyawardsModel.parse(element);
          awardsList.add(model);
        }
      });
    }
    view?.streamController.add(0);
  }
}
