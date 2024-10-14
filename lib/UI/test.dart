import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doghero_app/models/dog.dart';
import 'package:doghero_app/services/api.dart';
import 'package:doghero_app/utils/routes.dart';
import 'package:doghero_app/UI/dog_details/details_page.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<Dog> _dogs = [];

  _loadDogs() async {
    try {
      List<Dog> dogs = await DogApi.allDogsFromFirestore();
      setState(() {
        _dogs = dogs;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _addDog() async {
    //only for testing, add the dog to the db
    try {
      await FirebaseFirestore.instance.collection('dogs').add(
        {
          "name": "Dalinar",
          "adopted": false,
          "pictures": [
            "https://firebasestorage.googleapis.com/v0/b/doghero-832db.appspot.com/o/dalinar.jpg?alt=media&token=871898d7-cacc-47fe-8748-3eac2b16fc3e",
            "https://firebasestorage.googleapis.com/v0/b/doghero-832db.appspot.com/o/dalinar.jpg?alt=media&token=871898d7-cacc-47fe-8748-3eac2b16fc3e"
          ],
          "like_counter": 6,
          "location": "Los Andes, CL",
          "dogtributes": ["fuerte", "protector", "microchipeado", "leal"],
          "description":
              "Soy el guardián de mi hogar, siempre fiel y dispuesto a defender a mi manada con honor. 🐕🛡️",
          "image_url":
              "https://firebasestorage.googleapis.com/v0/b/doghero-832db.appspot.com/o/dalinar.jpg?alt=media&token=871898d7-cacc-47fe-8748-3eac2b16fc3e"
        },
      );
      _loadDogs(); // Refresh the list after adding a new dog
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  Widget _buildDogItem(BuildContext context, int index) {
    Dog dog = _dogs[index];
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () => _navigateToDogDetails(dog, index),
              leading: Hero(
                tag: index,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(dog.avatarUrl),
                ),
              ),
              title: Text(dog.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  )),
              subtitle: Text(dog.description),
              isThreeLine: true,
              dense: false,
            )
          ],
        ),
      ),
    );
  }

  void _navigateToDogDetails(Dog dog, Object avatarTag) {
    Navigator.of(context).push(FadePageRoute(
        builder: (c) {
          return DogDetailsPage(dog, avatarTag: avatarTag);
        },
        settings: const RouteSettings()));
  }

  Widget _getAppTittleWidget() {
    return const Text(
      'Lista de perros',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32.0),
    );
  }

  Future<void> refresh() {
    _loadDogs();
    return Future<void>.value();
  }

  Widget _getListViewWidget() {
    return Flexible(
        child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _dogs.length,
              itemBuilder: _buildDogItem,
            )));
  }

  Widget _buildBody() {
    return Container(
        margin: const EdgeInsets.fromLTRB(8.0, 56.0, 8.0, 0.0),
        child: Column(
          children: [_getAppTittleWidget(), _getListViewWidget()],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange,
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: _addDog,
          child: const Icon(Icons.add),
        ));
  }
}
