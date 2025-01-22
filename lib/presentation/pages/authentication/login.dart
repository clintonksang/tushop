import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tushop/application/utils/globals.dart';

import '../../../application/router/router.dart';
import '../../widgets/auth_page_manager.dart';
import '../../widgets/customTextField.dart';
import '../../widgets/phoneField.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPhoneSelected = false;
  bool isLoading = false;
  String phoneFromCache = '';

  @override
  void initState() {
    super.initState();
    _prefillEmail();
    _getPhone();
  }
 
  Future<void> _prefillEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    phoneController.text = prefs.getString('email') ?? '';
  }

  Future<void> _getPhone() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneFromCache = prefs.getString('phone') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageManager(
      pagetitle: 'login.login'.tr(),
      onButtonPressed: () {
        if (isPhoneSelected) {
        } else {
          emailLogin();
        }
      },
      buttontext: 'login.login'.tr(),
      pagedescription: 'login.description'.tr(),
      children: Column(
        children: [
          
                  isPhoneSelected
              ? PhoneField(
                  phoneController: phoneController,
                )
              : CustomTextField(
                  controller: phoneController,
                  hint: isPhoneSelected
                      ? "register.hint_phone".tr()
                      : "register.hint_email".tr(),
                  title:
                      isPhoneSelected ? "login.phone".tr() : "login.email".tr(),
                  keyboardType: isPhoneSelected
                      ? TextInputType.phone
                      : TextInputType.emailAddress,
                ),
          SizedBox(height: 20),
          CustomTextField(
            controller: passwordController,
            isPassword: true,
            hint: 'register.hint_password'.tr(),
            title: 'login.password'.tr(),
            keyboardType: TextInputType.text,
          ),
          isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
        ],
      ),
    );
  }

  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(email);
  }

  void emailLogin() async {
    setState(() {
      isLoading = true;
    });

    if (isValidEmail(phoneController.text) &&
        passwordController.text.isNotEmpty) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: phoneController.text,
          password: passwordController.text,
        );
        User? user = userCredential.user;
        if (user != null && user.emailVerified) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(phoneFromCache)
              .update({"verified": true});

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);

          Navigator.pushNamed(context, AppRouter.home);
        } else {
          showErrorDialog('Please verify your email before logging in.');
        }
      } on FirebaseAuthException catch (e) {
        handleFirebaseAuthError(e);
      }
    } else {
      showErrorDialog('Please enter a valid email and password.');
    }

    setState(() {
      isLoading = false;
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error Signin in'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void handleFirebaseAuthError(FirebaseAuthException e) {
    String errorMessage;
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No user found for that email.';
        break;
      case 'wrong-password':
        errorMessage = 'Wrong password provided for that user.';
        break;
      case 'user-disabled':
        errorMessage = 'This user has been disabled.';
        break;
      case 'too-many-requests':
        errorMessage = 'Too many requests. Try again later.';
        break;
      case 'operation-not-allowed':
        errorMessage = 'Signing in with Email and Password is not enabled.';
        break;
      default:
        errorMessage = 'Login failed: ${e.message}';
        break;
    }
    showErrorDialog(errorMessage);
  }
}
