import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_store/presentation/routing/route_names.dart';
import 'package:tennis_store/presentation/screens/auth/sign_in/sign_in_screen.dart';
import 'package:tennis_store/presentation/screens/auth/sign_up/sign_up_screen.dart';
import 'package:tennis_store/presentation/screens/home/home.dart';
import 'package:tennis_store/presentation/screens/home/store/store_screen.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final pageController = PageController(initialPage: 0);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/movie/app_background.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Home();
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
                                      final isExistingUser = await checkIfEmailInUse(
                                        emailController.text.trim(),
                                        _firestore,
                                      );

                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => Padding(
                                          padding: const EdgeInsets.symmetric(),
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: AppColorStyles.background,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(25),
                                              ),
                                            ),
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset('assets/loading.gif'),
                                                  Space.horizontal(20.0),
                                                  Text(
                                                    isExistingUser
                                                        ? 'You`re logged in...'
                                                        : 'You`ve created an account...',
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
                                      );

                                      if (isExistingUser) {
                                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                                          email: emailController.text.trim(),
                                          password: passwordController.text.trim(),
                                        );
                                      } else {
                                        await _firestore.collection('emails').doc(emailController.text.trim()).set({
                                          'email': emailController.text.trim(),
                                        });
                                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                          email: emailController.text.trim(),
                                          password: passwordController.text.trim(),
                                        );
                                      }

                                      Navigator.of(context).pop(); // Close the dialog
                                      context.pushNamed(RouteNames.home);
                                    },
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: AppColorStyles.background,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/loading.gif'),
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
                                  )
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
              onPressed: () async {
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
                context.goNamed(RouteNames.home);
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
      final querySnapshot = await firebaseFirestore.collection('emails').where('email', isEqualTo: emailAddress).get();

      return querySnapshot.docs.isNotEmpty;
    } catch (error) {
      return false;
    }
  }

  final List<Map<String, dynamic>> products = [
    {
      "product_name": "Nike Court Dri-FIT Tennis Skirt",
      "image_name": "nike_court_dri_fit_skirt.jpg",
      "price": "59.99",
      "manufacturer": "Nike"
    },
    {
      "product_name": "Nike Flex Ace Tennis Shorts",
      "image_name": "nike_flex_ace_shorts.jpg",
      "price": "49.99",
      "manufacturer": "Nike"
    },
    {
      "product_name": "Wilson Pro Staff 97 Tennis Racket",
      "image_name": "wilson_pro_staff_97.jpg",
      "price": "249.99",
      "manufacturer": "Wilson"
    },
    {
      "product_name": "Wilson Roland Garros Team Bag",
      "image_name": "wilson_roland_garros_bag.jpg",
      "price": "89.99",
      "manufacturer": "Wilson"
    },
    {
      "product_name": "Wilson Ultra 100 Tennis Racket With balls",
      "image_name": "wilson_ultra_100.jpg",
      "price": "269.99",
      "manufacturer": "Wilson"
    }
  ];

  // Future<void> loadProductsToFirestore() async {
  //   final firestore = FirebaseFirestore.instance;
  //   final collection = firestore.collection('products');

  //   for (var product in products) {
  //     await collection.add(product);
  //   }
  // }
}
