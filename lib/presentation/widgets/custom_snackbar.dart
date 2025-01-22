import 'package:flutter/material.dart';
 
import '../../application/utils/colors.dart';
import '../../application/utils/typography.dart';

class CustomSnackbar extends StatelessWidget {
  final String message;

  const CustomSnackbar({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ).merge(AppTextStyles.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

void showCustomSnackbar(BuildContext context, String text) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => CustomSnackbar(message: text),
  );

  overlay?.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 4)).then((_) {
    overlayEntry.remove();
  });
}