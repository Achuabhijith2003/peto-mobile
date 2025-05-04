import 'package:flutter/material.dart';
import 'package:peto/providers/auth_provider.dart';
import 'package:peto/screens/auth/loginScreen.dart';
import 'package:peto/screens/home_screen.dart';
import 'package:peto/screens/navbar.dart';
import 'package:peto/screens/onboardings/onBoardingScreen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/app_logo.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    if (authProvider.isAuth) {
      return const CustomNavBarCurved();
      ;
    } else if (authProvider.isnewUser) {
      // return const AuthScreen();
      return const OnBoardingScreen();
    } else {
      return SignInScreen();
    }
  }
}
