import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../application/router/router.dart';
import '../../widgets/auth_page_manager.dart';
import '../../widgets/otp_field.dart';

class OtpScreen extends StatelessWidget {
  final String verificationCode;
  const OtpScreen({super.key, required this.verificationCode});

  @override
  Widget build(BuildContext context) {
    return AuthPageManager(
      pagetitle: 'register.verify_phone'.tr(),
      onButtonPressed: () {
        Navigator.pushNamed(context, AppRouter.kycpage);
      },
      buttontext: "home.continue".tr(),
      pagedescription: "register.enter_otp".tr(),
      children: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * .6,
          child: Column(
            children: [OTPField(verificationId: verificationCode)],
          ),
        ),
      ),
    );
  }
}
