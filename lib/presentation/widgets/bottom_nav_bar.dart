import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_store/presentation/routing/route_names.dart';
import 'package:tennis_store/presentation/styles/app_color_styles.dart';

class BottomNavBar extends StatelessWidget {
  final PageController pageController;
  const BottomNavBar({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 80,
      color: Colors.transparent,
      elevation: 5,
      notchMargin: 0,
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColorStyles.secondary.withOpacity(0.2),
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.fastEaseInToSlowEaseOut,
                );
              },
              icon: const Icon(
                Icons.store_outlined,
                color: AppColorStyles.blackText,
                size: 40,
              ),
            ),
            IconButton(
                onPressed: () {
                  pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastEaseInToSlowEaseOut,
                  );
                },
                icon: const Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColorStyles.blackText,
                  size: 40,
                )),
            IconButton(
                onPressed: () {
                  pageController.animateToPage(
                    2,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastEaseInToSlowEaseOut,
                  );
                },
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: AppColorStyles.blackText,
                  size: 40,
                ))
          ],
        ),
      ),
    );
  }
}
