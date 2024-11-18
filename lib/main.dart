import 'package:doghero_app/config/dark_theme.dart';
import 'package:doghero_app/config/ligth_theme.dart';
import 'package:doghero_app/models/user.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:doghero_app/services/firebase_service.dart';
import 'package:doghero_app/utils/splash_screen.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // Este navigator key es para poder navegar desde cualquier parte de la app

  await Firebase.initializeApp();
  FirebaseService fs = FirebaseService(navigatorKey);
  // se inicializa el servicio de firebase para el manejo de la base de datos, el storage y la autenticación
  await fs.init();

  runApp(DogHero(navigatorKey: navigatorKey));
}

class DogHero extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const DogHero({
    super.key,
    required this.navigatorKey,
  });

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
          navigatorKey: navigatorKey,  // se le pasa el navigator key a la app, para que pueda mostrar las alertas
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
