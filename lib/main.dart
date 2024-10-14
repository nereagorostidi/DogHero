import 'package:doghero_app/UI/dog_list.dart';
import 'package:doghero_app/UI/auth/login.dart';
import 'package:doghero_app/injection.dart';
import 'package:doghero_app/models/user.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:doghero_app/services/wrapper.dart';
import 'package:doghero_app/utils/splash_screen.dart';
import 'package:flutter/src/material/theme_data.dart';

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
          theme: ThemeData(

              /*primaryColor: Color(0xFFFF5722),
              primaryColorDark: Color(0xFFe64a19),
              primaryColorLight: Color(0xFFffccbc),
              secondaryHeaderColor: Color(0xFF757575),
              dividerColor: Color(0xFFBDBDBD),*/
              //colorSchemeSeed: Color(0xFF795548),
              fontFamily: 'Ubuntu',
              useMaterial3: true),
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ));
  }
}
