import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doghero_app/UI/dog_list.dart';
import 'package:doghero_app/UI/test.dart';
import 'package:doghero_app/main.dart';
import 'package:doghero_app/models/user.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:doghero_app/services/db.dart';
import 'package:provider/provider.dart';
import 'package:doghero_app/UI/preferencias.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: _auth.user,
      initialData: null,
      child: Consumer<User?>(
        builder: (context, user, _) {
          return StreamProvider<QuerySnapshot?>.value(
            value: user != null ? DatabaseService(uid: user.uid).users : null,
            initialData: null,
            child: WillPopScope(  // Add WillPopScope to handle back button
              onWillPop: () async => false,  // Disable back button
              child: Scaffold(
                backgroundColor: Colors.orange,
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 87, 88, 88),
                  elevation: 0.0,
                  title: const Text('DogHero'),
                  actions: <Widget>[
                    PopupMenuButton<String>(
                      onSelected: (String result) async {
                        if (result == 'Salir') {
                          // Remove the navigation stack before signing out
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          await _auth.signOut();
                        } else if (result == 'Preferencias') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Preferencias()),
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Preferencias',
                          child: Text('Preferencias'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Salir',
                          child: Text('Salir'),
                        ),
                      ],
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
                    CurvedNavigationBar(
                      key: _bottomNavigationKey,
                      index: _page,
                      animationDuration: const Duration(milliseconds: 200),
                      height: 50.0,
                      backgroundColor: const Color.fromARGB(255, 87, 88, 88),
                      items: const <Widget>[
                        Icon(Icons.home, size: 30),
                        Icon(Icons.list, size: 30),
                        Icon(Icons.add, size: 30),
                      ],
                      onTap: (index) {
                        setState(() {
                          _page = index;
                          if (index == 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Test()),
                            );
                          }
                          else if (index == 0) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          }
                        });
                      },
                      letIndexChange: (value) => true,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}