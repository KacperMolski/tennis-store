import 'package:go_router/go_router.dart';
import 'package:tennis_store/presentation/screens/screens.dart';

class AuthRouter {
  static const String _prefix = 'home/auth';
  static const String signIn = '$_prefix/sign-in';
  static const String signUp = '$_prefix/sign-up';
  static const String verifyEmail = '$_prefix/verify-email';

  const AuthRouter._();

  static StatefulShellBranch getRoute() {
    return StatefulShellBranch(
      routes: [
        _signIn(),
        _signUp(),
      ],
    );
  }

  static GoRoute _signIn() {
    return GoRoute(
      path: signIn,
      builder: (_, state) {
        return Screens.signIn();
      },
    );
  }

  static GoRoute _signUp() {
    return GoRoute(
      path: signUp,
      builder: (_, state) {
        return Screens.signUp();
      },
    );
  }
}
