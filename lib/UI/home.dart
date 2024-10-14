import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doghero_app/UI/dog_list.dart';
import 'package:doghero_app/UI/test.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:doghero_app/services/db.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot?>.value(
      value: DatabaseService(uid: '').users,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors
            .orange, //placeholder this need to be changed to our color palette
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 87, 88,
              88), //placeholder this need to be changed to our color palette
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
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
                    Text("Perros destacados, informacion relevante, tbd")
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          //
                        },
                      ),
                      const Text('Preferencias'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.pets),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DogList()), //placeholder, but i set it to test cuz the dog_list tries to sign in with google on opening, virtually the same but without the google sign in
                          );
                        },
                      ),
                      const Text('Perros'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.question_mark),
                        onPressed: () {
                          //
                        },
                      ),
                      const Text('Placeholder'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
