import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tushop/application/utils/typography.dart';
import 'package:tushop/presentation/widgets/custom_fab.dart';

import '../../application/utils/colors.dart';
import '../../application/utils/globals.dart';
import 'app_logo.dart';

class AuthPageManager extends StatelessWidget {
  final String pagetitle;
  final String buttontext;
  final String pagedescription;
  final VoidCallback onButtonPressed;
  final Widget? children;
  const AuthPageManager({
    super.key,
    required this.children,
    required this.pagetitle,
    required this.pagedescription,
    this.buttontext = "Continue",
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Page Title
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        pagetitle,
                      ).largeBold(),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Page Description
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        pagedescription,
                      ).normal(),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Children widget
                  children ?? Container(),

                  const Spacer(),

                  // Button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        child: CustomFAB(
                          text: buttontext,
                          textcolor: Colors.white,
                          onPressed: onButtonPressed,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
