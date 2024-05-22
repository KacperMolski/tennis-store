import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_store/presentation/routing/route_names.dart';
import 'package:tennis_store/presentation/screens/auth/sign_in/sign_in_screen.dart';
import 'package:tennis_store/presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'package:tennis_store/presentation/screens/initial_screen/initial_screen.dart';
import 'package:tennis_store/presentation/screens/store/store_screen.dart';

class RouteConfig {
  static GoRouter returnRouter() {
    return GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.initial,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: InitialScreen(),
            );
          },
        ),
        GoRoute(
          path: '/sign-in',
          name: RouteNames.signIn,
          pageBuilder: (context, state) {
            return MaterialPage(
              child: SignInScreen(
                passwordController: TextEditingController(text: ''),
                emailContoller: TextEditingController(text: ''),
                measure: const Size(10, 10),
              ),
            );
          },
        ),
        GoRoute(
          path: '/sign-up',
          name: RouteNames.signUp,
          pageBuilder: (context, state) {
            return MaterialPage(
              child: SignUpScreen(
                controller: TextEditingController(text: ''),
                measure: const Size(10, 10),
              ),
            );
          },
        ),
        GoRoute(
          path: '/storeScreen',
          name: RouteNames.storeScreen,
          pageBuilder: (context, state) {
            return const MaterialPage(
              child: StoreScreen(),
            );
          },
        ),
      ],
    );
  }
}
