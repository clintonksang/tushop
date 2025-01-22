import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../application/utils/colors.dart';
import '../../application/utils/typography.dart';

class CustomTextField extends StatefulWidget {
  final String? title;
  final String hint;

  double width;
  final bool isPassword;
  final bool isDateSelector;
  VoidCallback? onDateSelect;
  final TextInputType keyboardType;

  final TextEditingController controller;

  CustomTextField({
    super.key,
    required this.title,
    this.width = double.infinity,
    this.isPassword = false,
    this.onDateSelect,
    this.isDateSelector = false,
    this.keyboardType = TextInputType.text,
    required this.hint,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = true; // For toggling password visibility

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onDateSelect,
      child: Container(
        height: 80,
        width: widget.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, left: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (widget.title != null)
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.title!,
                      style: AppTextStyles.medium.copyWith(fontSize: 10),
                    ),
                  ),
                ),
              Expanded(
                flex: 1,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    FieldItems(
                      hintText: widget.hint,
                      inputType: TextInputType.text,
                      isBorderVisible: false,
                      keyboardType: widget.isPassword
                          ? TextInputType.visiblePassword
                          : widget.keyboardType,
                      controller: widget.controller,
                      obscureText: widget.isPassword ? isObscured : false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '${widget.title} cannot be empty';
                        }
                        return null;
                      },
                    ),
                    if (widget.isPassword)
                      IconButton(
                        icon: Icon(
                          isObscured ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isObscured = !isObscured;
                          });
                        },
                      ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class FieldItems extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final bool isBorderVisible;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;

  const FieldItems({
    Key? key,
    required this.hintText,
    required this.inputType,
    this.keyboardType = TextInputType.text,
    this.isBorderVisible = true,
    required this.controller,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.topCenter,
        child: TextFormField(
          controller: controller,
          keyboardType: inputType,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: isBorderVisible ? OutlineInputBorder() : InputBorder.none,
            hintStyle: TextStyle(color: grey),
            focusedBorder:
                isBorderVisible ? OutlineInputBorder() : InputBorder.none,
            enabledBorder:
                isBorderVisible ? OutlineInputBorder() : InputBorder.none,
          ),
        ),
      ),
    );
  }
}
