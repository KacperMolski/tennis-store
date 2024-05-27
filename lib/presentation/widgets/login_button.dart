import 'package:flutter/material.dart';
import 'package:tennis_store/presentation/styles/app_color_styles.dart';
import 'package:tennis_store/presentation/styles/app_text_styles.dart';

class LoginButton extends StatelessWidget {
  final Size measure;
  final bool isMain;
  final String text;
  final void Function()? onPressed;
  const LoginButton({
    super.key,
    required this.measure,
    required this.isMain,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isMain ? AppColorStyles.background : AppColorStyles.transparent,
          borderRadius: BorderRadius.circular(600),
          border: isMain
              ? null
              : Border.all(
                  color: AppColorStyles.primary,
                ),
        ),
        width: measure.width * 0.35,
        height: measure.height * 0.055,
        child: Center(
          child: Text(
            text,
            style: AppTextStyles.buttonText(isMain),
          ),
        ),
      ),
    );
  }
}
