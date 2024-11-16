import 'package:doghero_app/config/dark_theme.dart';
import 'package:doghero_app/config/ligth_theme.dart';
import 'package:doghero_app/models/user.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:doghero_app/utils/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DogHero());
}

class DogHero extends StatelessWidget {
  const DogHero({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
          /*theme: ThemeData(
              primaryColor: Color(0xFFFF5722),
              primaryColorDark: Color(0xFFe64a19),
              primaryColorLight: Color(0xFFffccbc),
              secondaryHeaderColor: Color(0xFF757575),
              dividerColor: Color(0xFFBDBDBD),
              //colorSchemeSeed: Color(0xFF795548),
              fontFamily: 'Ubuntu',
              useMaterial3: false),*/
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode
              .system, // Cambia automáticamente entre light y dark según el sistema
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ));
  }
}
