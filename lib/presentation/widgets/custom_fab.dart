import 'package:flutter/material.dart';
import 'package:tushop/application/utils/colors.dart';
import 'package:tushop/application/utils/globals.dart';
import 'package:tushop/application/utils/typography.dart';

class CustomFAB extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? textcolor;
  const CustomFAB(
      {super.key,
      required this.text,
      required this.onPressed,
      this.textcolor = Colors.white,
      this.color = primaryColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50,
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.medium
                .copyWith(color: textcolor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
