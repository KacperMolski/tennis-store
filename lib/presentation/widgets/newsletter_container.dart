import 'package:flutter/material.dart';
import 'package:tennis_store/presentation/styles/app_color_styles.dart';
import 'package:tennis_store/presentation/styles/app_text_styles.dart';
import 'package:tennis_store/presentation/widgets/space.dart';

class NewsletterContainer extends StatelessWidget {
  final String path;
  final String title;
  final String buttonText;
  final void Function()? onPressed;

  const NewsletterContainer({
    super.key,
    required this.path,
    required this.title,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 300.0,
        decoration: BoxDecoration(
          color: AppColorStyles.background,
          image: DecorationImage(
            image: NetworkImage(
              path,
            ),
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(
                0.3,
              ),
              BlendMode.darken,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              30,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: AppTextStyles.greenText(),
            ),
            const Space.vertical(
              20.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorStyles.background,
                side: const BorderSide(
                  width: 1,
                  color: AppColorStyles.greentext,
                ),
              ),
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: AppTextStyles.buttonText(true).copyWith(
                  fontSize: 12.0,
                ),
              ),
            ),
            const Space.vertical(
              20.0,
            )
          ],
        ),
      ),
    );
  }
}
