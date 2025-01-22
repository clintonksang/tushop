import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tushop/presentation/widgets/custom_fab.dart';

import '../../../application/router/router.dart';
import '../../../application/utils/colors.dart';
import '../../../application/utils/globals.dart';
import '../../../application/utils/typography.dart';
import '../../widgets/app_logo.dart';

class Launcher extends StatefulWidget {
  const Launcher({super.key});

  @override
  State<Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            top: 0,
            left: 0,
            right: 0,
            child: Container(
                child: Image.asset(
              "assets/images/cover.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            )),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [black.withOpacity(0.2), black.withOpacity(0.8)],
              )),
            ),
          ),
          Positioned(
            bottom: 50,
            left: defaultPadding,
            right: defaultPadding,
            child: Column(
              children: [
                SizedBox(
                  height: defaultPadding,
                ),
                CustomFAB(
                    textcolor: black,
                    color: white,
                    text: "login.login".tr(),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.login);
                    }),
                SizedBox(
                  height: 10,
                ),
                CustomFAB(
                    textcolor: white,
                    text: "register.register".tr(),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouter.phone);
                    }),
              ],
            ),
          ),
          Positioned(
              top: 150,
              left: defaultPadding,
              right: defaultPadding,
              child: Column(
                children: [
                  Logo(),
                  Text(
                    "home.app_name".tr(),
                    style: AppTextStyles.largeBold.copyWith(color: white),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
