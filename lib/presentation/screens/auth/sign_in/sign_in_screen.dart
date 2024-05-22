import 'package:flutter/material.dart';
import 'package:tennis_store/presentation/styles/app_color_styles.dart';
import 'package:tennis_store/presentation/styles/app_text_styles.dart';
import 'package:tennis_store/presentation/widgets/login_button.dart';
import 'package:tennis_store/presentation/widgets/space.dart';

class SignInScreen extends StatelessWidget {
  final Size measure;
  final void Function()? onNextPressed;
  final void Function()? onBackPressed;
  final TextEditingController passwordController;
  final TextEditingController emailContoller;
  const SignInScreen({
    super.key,
    required this.measure,
    this.onNextPressed,
    this.onBackPressed,
    required this.passwordController,
    required this.emailContoller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox.shrink(),
        const Space.vertical(25.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What’s your password?',
              style: AppTextStyles.titleConfiguration(),
              textAlign: TextAlign.start,
            ),
            Row(
              children: [
                Text(
                  emailContoller.text,
                  style: AppTextStyles.loginSmallEmail(),
                  textAlign: TextAlign.start,
                ),
                const Space.horizontal(10.0),
                TextButton(
                  onPressed: onBackPressed,
                  child: Text(
                    'Edit',
                    style: AppTextStyles.loginSmalltextButton(),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            const Space.vertical(50.0),
            TextFormField(
              controller: passwordController,
              cursorColor: AppColorStyles.primary,
              cursorHeight: 50,
              style: AppTextStyles.buttonText(false),
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding: const EdgeInsets.all(20.0),
                hintStyle: AppTextStyles.buttonText(false),
                focusColor: AppColorStyles.primary,
                fillColor: AppColorStyles.primary,
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  borderSide: BorderSide(
                    color: AppColorStyles.primary,
                  ),
                ),
                hoverColor: AppColorStyles.primary,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  borderSide: BorderSide(
                    color: AppColorStyles.primary,
                  ),
                ),
              ),
            )
          ],
        ),
        const Space.vertical(50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LoginButton(
              measure: measure,
              isMain: false,
              text: 'Back',
              onPressed: onBackPressed,
            ),
            const Space.horizontal(25),
            LoginButton(
              measure: measure,
              isMain: true,
              text: 'Sign In',
              onPressed: onNextPressed,
            ),
          ],
        ),
      ],
    );
  }
}
