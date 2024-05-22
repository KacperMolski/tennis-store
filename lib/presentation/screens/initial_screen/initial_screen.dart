import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_store/presentation/routing/route_names.dart';
import 'package:tennis_store/presentation/screens/auth/sign_in/sign_in_screen.dart';
import 'package:tennis_store/presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'package:tennis_store/presentation/screens/store/store_screen.dart';
import 'package:tennis_store/presentation/styles/app_color_styles.dart';
import 'package:tennis_store/presentation/styles/app_text_styles.dart';
import 'package:tennis_store/presentation/widgets/login_button.dart';
import 'package:tennis_store/presentation/widgets/space.dart';

import 'package:video_player/video_player.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  late VideoPlayerController _controller;
  final pageController = PageController(initialPage: 0);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset("assets/movie/app_background.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    bool existing = false;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const StoreScreen();
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: SizedBox(
                  child: Stack(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Container(
                            color: Colors.black.withOpacity(0.7),
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: Padding(
                              padding: EdgeInsets.all(
                                _controller.value.size.width * 0.05,
                              ),
                              child: PageView(
                                physics: const NeverScrollableScrollPhysics(),
                                controller: pageController,
                                children: [
                                  initialHome(context),
                                  SignUpScreen(
                                    measure: _controller.value.size,
                                    onBackPressed: () {
                                      pageController.animateToPage(
                                        0,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.fastEaseInToSlowEaseOut,
                                      );
                                    },
                                    onNextPressed: () async {
                                      pageController.animateToPage(
                                        2,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.fastEaseInToSlowEaseOut,
                                      );
                                    },
                                    controller: emailController,
                                  ),
                                  SignInScreen(
                                    passwordController: passwordController,
                                    emailContoller: emailController,
                                    measure: _controller.value.size,
                                    onBackPressed: () {
                                      pageController.animateToPage(
                                        1,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.fastEaseInToSlowEaseOut,
                                      );
                                    },
                                    onNextPressed: () async {
                                      print('Isnieje? $existing');
                                      print(
                                          'email ${emailController.text.trim()} haslo: ${passwordController.text.trim()}');
                                      await checkIfEmailInUse(
                                        emailController.text,
                                        _firestore,
                                      )
                                          ? {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) => Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 80.0,
                                                  ),
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                      color: AppColorStyles.background,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(15),
                                                      ),
                                                    ),
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          const CircularProgressIndicator(
                                                            color: AppColorStyles.blackText,
                                                          ),
                                                          Space.horizontal(20.0),
                                                          Text(
                                                            'You`re logged in...',
                                                            style: AppTextStyles.circuralProcess(),
                                                          ),
                                                          Text(
                                                            'It might take a few seconds',
                                                            style: AppTextStyles.miniCircuralProcess(),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                                email: emailController.text.trim(),
                                                password: passwordController.text.trim(),
                                              )
                                            }
                                          : {
                                              await _firestore
                                                  .collection('emails')
                                                  .doc(emailController.text.trim())
                                                  .set({
                                                'email': emailController.text.trim(),
                                              }),
                                              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                                email: emailController.text.trim(),
                                                password: passwordController.text.trim(),
                                              )
                                            };
                                      context.pushNamed(
                                        RouteNames.storeScreen,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  Column initialHome(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tennis Store',
          style: AppTextStyles.headerText(),
        ),
        const Space.vertical(25),
        Text(
          'Your space for wellness, your way. Move with us.',
          style: AppTextStyles.subtitleText(),
        ),
        const Space.vertical(50),
        Row(
          children: [
            LoginButton(
              measure: _controller.value.size,
              isMain: true,
              text: 'Join Us',
              onPressed: () {
                pageController.animateToPage(
                  1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.fastEaseInToSlowEaseOut,
                );
              },
            ),
            const Space.horizontal(0),
            LoginButton(
              measure: _controller.value.size,
              isMain: false,
              text: 'Store',
              onPressed: () {
                context.goNamed(
                  RouteNames.storeScreen,
                );
              },
            ),
          ],
        )
      ],
    );
  }

  Future<bool> checkIfEmailInUse(
    String emailAddress,
    FirebaseFirestore firebaseFirestore,
  ) async {
    try {
      // Fetch sign-in methods for the email address
      final querySnapshot = await firebaseFirestore.collection('emails').get();
      final emails = querySnapshot.docs.map((doc) => doc['email'] as String).toList();
      // In case list is not empty
      if (emails.isNotEmpty) {
        // Return true because there is an existing
        // user using the email address
        return true;
      } else {
        // Return false because email adress is not in use
        return false;
      }
    } catch (error) {
      // Handle error
      // ...
      return true;
    }
  }
}
