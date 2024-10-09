import 'package:flutter/material.dart';
import 'package:src/services/auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[200], //placeholder this need to be changed to our color palette
      appBar: AppBar(
        //backgroundColor: const Color.fromARGB(255, 87, 88, 88), //placeholder this need to be changed to our color palette
        elevation: 0.0,
        title: const Text('DogHero'),   
        actions: <Widget>[
          TextButton.icon(
            onPressed: () async {
              await _auth.signOut();
              //sign out
            },
            icon: const Icon(Icons.person),
            label: const Text('Salir'),
          ),
        ],
    )
    );
  }
}