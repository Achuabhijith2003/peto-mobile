import 'package:flutter/material.dart';
import 'package:peto/screens/auth/splash_screen.dart.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/pet_provider.dart';
import 'providers/owner_provider.dart';
import 'providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, PetProvider>(
          create: (_) => PetProvider(null),
          update: (_, auth, __) => PetProvider(auth.user?.uid),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OwnerProvider>(
          create: (_) => OwnerProvider(null),
          update: (_, auth, __) => OwnerProvider(auth.user?.uid),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder:
            (ctx, auth, _) => MaterialApp(
              title: 'Pet Profile App',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.teal,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.teal,
                  secondary: Colors.orangeAccent,
                ),
                fontFamily: 'Poppins',
                appBarTheme: const AppBarTheme(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  centerTitle: true,
                ),
              ),
              home: const SplashScreen(),
            ),
      ),
    );
  }
}
