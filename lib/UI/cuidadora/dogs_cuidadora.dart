import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doghero_app/UI/preferencias.dart';
import 'package:doghero_app/models/dog.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doghero_app/models/user.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doghero_app/UI/cuidadora/home_cuidadora.dart';

class DogsCuidadora extends StatefulWidget {
  const DogsCuidadora({super.key});

  @override
  State<DogsCuidadora> createState() => _DogsCuidadoraState();
}

class _DogsCuidadoraState extends State<DogsCuidadora> {
  final AuthService _auth = AuthService();
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  int _page = 1;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: _auth.user,
      initialData: null,
      child: Consumer<User?>(
        builder: (context, user, _) {
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('dogs')
                .where('id_cuidadora', isEqualTo: user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              List<Dog> dogs = snapshot.data!.docs.map((doc) {
                return Dog.fromJson(doc.data() as Map<String, dynamic>, doc.id);
              }).toList();

              return WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                backgroundColor: Colors.orange,
                  appBar: AppBar(
                    backgroundColor: const Color.fromARGB(255, 87, 88, 88),
                    elevation: 0.0,
                    title: const Text('Dogs a'),
                    actions: <Widget>[
                      PopupMenuButton<String>(
                        onSelected: (String result) async {
                          if (result == 'Salir') {
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
                  body: ListView.builder(
                    itemCount: dogs.length,
                    itemBuilder: (context, index) {
                      Dog dog = dogs[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(dog.avatarUrl),
                        ),
                        title: Text(dog.name),
                        subtitle: Text(dog.description),
                      );
                    },
                  ),
                  bottomNavigationBar: CurvedNavigationBar(
                    key: _bottomNavigationKey,
                    index: _page,
                    animationDuration: const Duration(milliseconds: 200),
                    height: 50.0,
                    backgroundColor: const Color.fromARGB(255, 87, 88, 88),
                    items: const <Widget>[
                      Icon(Icons.upload, size: 30),
                      Icon(Icons.list, size: 30),
                    ],
                    onTap: (index) {
                      setState(() {
                        _page = index;
                        if (index == 1) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => DogsCuidadora()),
                          );
                        } else if (index == 0) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => CuidadoraHome()),
                          );
                        }
                      });
                    },
                    letIndexChange: (value) => true,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}