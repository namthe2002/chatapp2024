import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_yoko/Controller/Account/AdminAccountController.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Models/Account/Account.dart';
import 'package:live_yoko/Models/Chat/PositionType.dart';
import 'package:live_yoko/Service/APICaller.dart';
import 'package:live_yoko/Utils/Utils.dart';

class AccountDetailController extends GetxController {
  List<PositionType> positionList = [
    PositionType(value: 2, title: TextByNation.getStringByKey('admin')),
    PositionType(value: 1, title: TextByNation.getStringByKey('leader')),
    PositionType(value: 0, title: TextByNation.getStringByKey('user')),
  ];
  RxBool isLoading = true.obs;
  Rx<Account> account = Account().obs;
  DateTime timeNow = DateTime.now();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    account.value = Get.arguments;
    isLoading.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }

  changeRole({required int index}) async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "roleId": positionList[index].value!,
        "uuid": account.value.uuid,
      };

      var data = await APICaller.getInstance()
          .post('v1/Account/change-role-account', param);
      if (data != null) {
        account.value.roleId = positionList[index].value!;
        account.refresh();
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'),
            message: TextByNation.getStringByKey('permission_successfully'));
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    }
  }

  resetPassWord() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    var param = {
      "keyCert": await Utils.generateMd5(
          Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
      "time": formattedTime,
      "phoneNumber": account.value.userName,
    };
    try {
      var data = await APICaller.getInstance()
          .post('v1/Account/reset-password', param);

      if (data != null) {
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'),
            message: TextByNation.getStringByKey('reset_pass_ss'));
        // Get.close(1);
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    } finally {
      isLoading.value = false;
    }
  }

  changeLock() async {
    String formattedTime = DateFormat('MM/dd/yyyy HH:mm:ss').format(timeNow);
    int status = 0;
    if (account.value.activeState == 0) {
      status = 1;
    }
    try {
      var param = {
        "keyCert":
            Utils.generateMd5(Constant.NEXT_PUBLIC_KEY_CERT + formattedTime),
        "time": formattedTime,
        "activeState": status,
        "uuid": account.value.uuid,
      };

      var data = await APICaller.getInstance()
          .post('v1/Account/toggle-lock-account', param);
      if (data != null) {
        account.value.activeState = status;
        account.refresh();
        var controller = Get.find<AdminAccountController>();
        controller.listContact.clear();
        await controller.getFriend(
            controller.selectPosition.value, controller.selectStatus.value + 1);
        Utils.showSnackBar(
            title: TextByNation.getStringByKey('notification'),
            message: TextByNation.getStringByKey('status_successfully'));
      }
    } catch (e) {
      Utils.showSnackBar(
          title: TextByNation.getStringByKey('notification'), message: '$e');
    }
  }
}
