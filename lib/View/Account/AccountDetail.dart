import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_yoko/Controller/Account/AccountDetailController.dart';
import 'package:live_yoko/Global/ColorValue.dart';
import 'package:live_yoko/Global/Constant.dart';
import 'package:live_yoko/Global/TextByNation.dart';
import 'package:live_yoko/Navigation/Navigation.dart';
import 'package:live_yoko/Utils/Utils.dart';

class AccountDetail extends StatelessWidget {
  AccountDetail({Key? key}) : super(key: key);

  Size size = const Size(0, 0);

  final controller = Get.put(AccountDetailController());

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Get.delete<AccountDetailController>();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(TextByNation.getStringByKey('account_detail')),
        ),
        body: Obx(() => controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                color: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
                child: Column(
                  children: [
                    Expanded(
                        child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            controller.account.value.avatar != null
                                ? ClipOval(
                                    child: Image.network(
                                    Constant.BASE_URL_IMAGE +
                                        controller.account.value.avatar!,
                                    width: 94,
                                    height: 94,
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return SvgPicture.asset(
                                        'asset/images/default.svg',
                                        key: UniqueKey(),
                                        fit: BoxFit.cover,
                                        width: 94,
                                        height: 94,
                                      );
                                    },
                                  ))
                                : Container(
                                    width: 94,
                                    height: 94,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: Utils.getGradientForLetter(
                                            controller.account.value.fullName !=
                                                    null
                                                ? '${controller.account.value.fullName}'
                                                : controller
                                                    .account.value.userName!)),
                                    child: Center(
                                        child: Text(
                                      Utils.getInitialsName(controller
                                                      .account.value.fullName !=
                                                  null
                                              ? '${controller.account.value.fullName}'
                                              : controller
                                                  .account.value.userName!)
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    )),
                                  ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.account.value.fullName != null
                                      ? '${controller.account.value.fullName}'
                                      : controller.account.value.userName!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  controller.account.value.roleId == 2
                                      ? TextByNation.getStringByKey('admin')
                                      : controller.account.value.roleId == 1
                                          ? TextByNation.getStringByKey(
                                              'leader')
                                          : TextByNation.getStringByKey('user'),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(146, 154, 169, 1)),
                                ),
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        Opacity(
                          opacity: .5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _item(
                                  title:
                                      TextByNation.getStringByKey('username'),
                                  value: controller.account.value.userName!),
                              SizedBox(
                                height: 12,
                              ),
                              _item(
                                  title: TextByNation.getStringByKey('Email'),
                                  value: controller.account.value.email!),
                              SizedBox(
                                height: 12,
                              ),
                              _item(
                                  title:
                                      TextByNation.getStringByKey('first_name'),
                                  value: controller.account.value.fullName!),
                              // SizedBox(
                              //   height: 12,
                              // ),
                              // _item(
                              //     title:
                              //         TextByNation.getStringByKey('last_name'),
                              //     value: controller.account.value.fullName!)
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            bottomSheetItem();
                          },
                          child: _item(
                              title: TextByNation.getStringByKey('position'),
                              value: controller.account.value.roleId == 2
                                  ? TextByNation.getStringByKey('admin')
                                  : controller.account.value.roleId == 1
                                      ? TextByNation.getStringByKey('leader')
                                      : TextByNation.getStringByKey('user')),
                        )
                      ],
                    )),
                    InkWell(
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => _dialogConfirm(
                            title:
                            "${TextByNation.getStringByKey('reset_pass')} '${controller.account.value.fullName}'",
                            description:
                            TextByNation.getStringByKey('reset_password_confirm'),
                            onTap: () async {
                              await controller.resetPassWord();
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(right: 20, left: 20, top: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: ColorValue.colorBrCmr),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Center(
                              child: Text(
                            TextByNation.getStringByKey('reset_pass'),
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorValue.neutralColor),
                          )),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await controller.changeLock();
                      },
                      child: Container(
                        height: 50,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        // padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: controller.account.value.activeState == 1
                                  ? [
                                      Color(0xFFFF9595),
                                      Color(0xFFFF4646),
                                    ]
                                  : [
                                      Color.fromRGBO(141, 255, 159, 1),
                                      Color.fromRGBO(0, 155, 62, 1),
                                    ],
                              stops: [0, 1],
                              transform: GradientRotation(185 * 3.14159 / 180),
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              controller.account.value.activeState == 1
                                  ? Icons.lock_outline_rounded
                                  : Icons.lock_open_rounded,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              controller.account.value.activeState == 1
                                  ? TextByNation.getStringByKey('lock_account')
                                  : TextByNation.getStringByKey(
                                      'unlock_account'),
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )),
      ),
    );
  }

  _item({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border:
              Border.all(width: 1.5, color: Color.fromRGBO(228, 230, 236, 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Color.fromRGBO(146, 154, 169, 1)),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }

  bottomSheetItem() {
    return showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Get.isDarkMode ? ColorValue.neutralColor : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      )),
      builder: (context) => Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Container(
                  width: 32,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color.fromRGBO(134, 140, 154, 1)),
                ),
              ),
              SizedBox(height: 12),
              Text(
                TextByNation.getStringByKey('position'),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 8),
              Text(
                TextByNation.getStringByKey('select_filter'),
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Color.fromRGBO(146, 154, 169, 1),
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.positionList.length,
                separatorBuilder: (context, index) => Container(
                  height: .5,
                  color: Color.fromRGBO(228, 230, 236, 1),
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      controller.changeRole(index: index);
                      Navigator.pop(context);
                    },
                    child: Obx(() => Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            controller.positionList[index].title!,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: controller.account.value.roleId ==
                                        controller.positionList[index].value!
                                    ? Color.fromRGBO(17, 185, 145, 1)
                                    : null),
                          ),
                        )),
                  );
                },
              ),
              SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }

  _dialogConfirm(
      {required String title,
        required String description,
        required GestureTapCallback onTap}) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              description,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(Get.context!);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      TextByNation.getStringByKey('cancel').toUpperCase(),
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      TextByNation.getStringByKey('confirm').toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(17, 185, 145, 1)),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
