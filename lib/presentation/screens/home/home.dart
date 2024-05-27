import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tennis_store/presentation/routing/route_names.dart';
import 'package:tennis_store/presentation/screens/home/basket/basket.dart';
import 'package:tennis_store/presentation/screens/home/store/store_screen.dart';
import 'package:tennis_store/presentation/styles/app_color_styles.dart';
import 'package:tennis_store/presentation/styles/app_text_styles.dart';
import 'package:tennis_store/presentation/widgets/bottom_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController _pageViewController;
  int _currentPageIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    _pageViewController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavBar(
        pageController: _pageViewController,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageViewController,
        children: [
          StoreScreen(),
          Basket(),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Profile'),
                    actions: [
                      IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                      ),
                    ],
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Kacper Molski',
                          style: AppTextStyles.normaltext(),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Scaffold(
                appBar: AppBar(
                  title: Text('Profile'),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                    ),
                  ],
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Log in to app',
                        style: AppTextStyles.normaltext(),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColorStyles.background,
                            side: const BorderSide(
                              width: 1,
                              color: AppColorStyles.greentext,
                            ),
                          ),
                          onPressed: () {
                            context.pushNamed(RouteNames.initial);
                          },
                          child: Text(
                            'CLICK ME TO LOG IN ',
                            style: AppTextStyles.buttonText(true).copyWith(fontSize: 12),
                          ))
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
