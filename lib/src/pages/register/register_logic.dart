import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_demo/src/common/apis.dart';
import 'package:openim_demo/src/res/strings.dart';
import 'package:openim_demo/src/routes/app_navigator.dart';
import 'package:openim_demo/src/utils/im_util.dart';
import 'package:openim_demo/src/widgets/im_widget.dart';

class RegisterLogic extends GetxController {
  var controller = TextEditingController();
  var showClearBtn = false.obs;
  var agreedProtocol = true.obs;
  var isPhoneRegister = true;
  var areaCode = "+86".obs;

  void nextStep() {
    if (isPhoneRegister &&
        !IMUtil.isPhoneNumber(areaCode.value, controller.text)) {
      IMWidget.showToast(StrRes.plsInputRightPhone);
      return;
    }
    if (!isPhoneRegister && !GetUtils.isEmail(controller.text)) {
      IMWidget.showToast(StrRes.plsInputRightEmail);
      return;
    }

    Apis.requestVerificationCode(
            areaCode: areaCode.value,
            phoneNumber: isPhoneRegister ? controller.text : null,
            email: !isPhoneRegister ? controller.text : null,
            usedFor: 1)
        .then((value) {
      if (value) {
        AppNavigator.startRegisterVerifyPhoneOrEmail(
            areaCode: areaCode.value,
            phoneNumber: isPhoneRegister ? controller.text : null,
            email: !isPhoneRegister ? controller.text : null,
            usedFor: 1);
      }
    });
  }

  void toggleProtocol() {
    agreedProtocol.value = !agreedProtocol.value;
  }

  @override
  void onReady() {
    controller.addListener(() {
      showClearBtn.value = controller.text.isNotEmpty;
    });
    super.onReady();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    isPhoneRegister = Get.arguments['registerWay'] == "phone";
    super.onInit();
  }

  void openCountryCodePicker() async {
    String? code = await IMWidget.showCountryCodePicker();
    if (null != code) {
      areaCode.value = code;
    }
  }
}
