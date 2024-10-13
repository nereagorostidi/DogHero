import 'package:doghero_app/UI/test.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, //placeholder this need to be changed to our color palette
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 87, 88, 88), //placeholder this need to be changed to our color palette
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
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/dogopng.png'),
            alignment: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            const Text(
              'Bienvenido a DogHero',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Encuentra el mejor cuidador para tu perro',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Test()), //placeholder, but i set it to test cuz the dog_list tries to sign in with google on opening, virtually the same but without the google sign in
                );
              },
              child: const Text('Ir a la lista de los perros'),
            ),
          ],
        ),
      ),
    );
  }
}

