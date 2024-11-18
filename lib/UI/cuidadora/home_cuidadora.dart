import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doghero_app/UI/cuidadora/dogs_cuidadora.dart';
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
import 'package:doghero_app/utils/constants.dart'; // Import the constants file

class CuidadoraHome extends StatefulWidget {
  CuidadoraHome({super.key});

  @override
  State<CuidadoraHome> createState() => _CuidadoraHomeState();
}

class _CuidadoraHomeState extends State<CuidadoraHome> {
  final AuthService _auth = AuthService();
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final _formkey = GlobalKey<FormState>();
  int _age = 0;
  String _name = '';
  String _color = '';
  String _description = '';
  String _energyLevel = '';
  String _location = '';
  String _sex = '';
  String _size = '';
  List<String> _images = [];

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
            child: WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.orange,
                appBar: AppBar(
                  backgroundColor: const Color.fromARGB(255, 87, 88, 88),
                  elevation: 0.0,
                  title: const Text('DogHero'),
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
                body: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Form(
                                  key: _formkey,
                                  child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: <Widget>[
                                    TextFormField(
                                      decoration: textFieldDecoration.copyWith(
                                      hintText: 'Name',
                                      suffixIcon: Icon(Icons.pets),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                                      onChanged: (value) {
                                      setState(() => _name = value);
                                      },
                                    ),
                                    SizedBox(height: 16.0),
                                    TextFormField(
                                      decoration: textFieldDecoration.copyWith(
                                      hintText: 'Age',
                                      suffixIcon: Icon(Icons.cake),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Enter an age' : null,
                                      onChanged: (value) {
                                      setState(() => _age = int.tryParse(value)!);
                                      },
                                    ),
                                    SizedBox(height: 16.0),
                                    TextFormField(
                                      decoration: textFieldDecoration.copyWith(
                                      hintText: 'Color',
                                      suffixIcon: Icon(Icons.color_lens),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Enter a color' : null,
                                      onChanged: (value) {
                                      setState(() => _color = value);
                                      },
                                    ),
                                    SizedBox(height: 16.0),
                                    TextFormField(
                                      decoration: textFieldDecoration.copyWith(
                                      hintText: 'Description',
                                      suffixIcon: Icon(Icons.description),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                                      onChanged: (value) {
                                      setState(() => _description = value);
                                      },
                                    ),
                                    SizedBox(height: 16.0),
                                    TextFormField(
                                      decoration: textFieldDecoration.copyWith(
                                      hintText: 'Energy Level',
                                      suffixIcon: Icon(Icons.battery_full),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Enter an energy level' : null,
                                      onChanged: (value) {
                                      setState(() => _energyLevel = value);
                                      },
                                    ),
                                    SizedBox(height: 16.0),
                                    TextFormField(
                                      decoration: textFieldDecoration.copyWith(
                                      hintText: 'Location',
                                      suffixIcon: Icon(Icons.location_on),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Enter a location' : null,
                                      onChanged: (value) {
                                      setState(() => _location = value);
                                      },
                                    ),
                                    SizedBox(height: 16.0),
                                    TextFormField(
                                      decoration: textFieldDecoration.copyWith(
                                      hintText: 'Sex',
                                      suffixIcon: Icon(Icons.transgender),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Enter a sex' : null,
                                      onChanged: (value) {
                                      setState(() => _sex = value);
                                      },
                                    ),
                                    SizedBox(height: 16.0),
                                    TextFormField(
                                      decoration: textFieldDecoration.copyWith(
                                      hintText: 'Size',
                                      suffixIcon: Icon(Icons.straighten),
                                      ),
                                      validator: (value) => value!.isEmpty ? 'Enter a size' : null,
                                      onChanged: (value) {
                                      setState(() => _size = value);
                                      },
                                    ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            print(user!.uid);
                                            if (_formkey.currentState!.validate()) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Dog uploaded')),
                                              );
                                            }
                                          },
                                          child: const Text('Upload Dog'),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
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
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}