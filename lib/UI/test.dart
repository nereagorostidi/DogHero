import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doghero_app/UI/dog_list.dart';
import 'package:doghero_app/UI/filter_screen.dart';
import 'package:doghero_app/UI/home.dart';
import 'package:doghero_app/UI/maps.dart';
import 'package:doghero_app/UI/preferencias.dart';
import 'package:doghero_app/models/dog.dart';
import 'package:doghero_app/services/api.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:doghero_app/utils/routes.dart';
import 'package:doghero_app/UI/dog_details/details_page.dart';
import 'package:doghero_app/utils/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../utils/constants.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  //estado mutable
  List<Dog> _dogs =
      []; // lista que se llenará cuando se carguen los datos desde JSON.
  List<Dog> _filteredDogs = [];
  List<Dog> _searchFilteredDogs = [];
  Set<String> _selectedSex = {};
  Set<String> _selectedSize = {};
  Set<String> _selectedAge = {};
  Set<String> _selectedEnergyLevel = {};

  _loadDogs() async {
    //asincrono por que es una operación que puede tardar un tiempo indeterminado en completarse
    /*String fileData = await DefaultAssetBundle.of(context).loadString(
        "assets/dogs.json"); //permite acceder a los recursos o assets incluidos en el proyecto
    setState(() {
      _dogs = DogApi.allDogsFromJson(
          fileData); //almacenas la información de cada gato en la lista
    });*/

    try {
      List<Dog> dogs = await DogApi.allDogsFromFirestore();
      setState(() {
        _dogs = dogs;
        _filteredDogs = dogs;
        _searchFilteredDogs = dogs;
        _selectedSex.clear();
        _selectedSize.clear();
        _selectedAge.clear();
        _selectedEnergyLevel.clear();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void _filterDogsSearch(String query) {
    final searchLower = query.toLowerCase();
    print("searchLower $searchLower");
    print("searchLower ${_dogs.length}");
    // Filter the dogs based on both the search query and selected filters
    final filtered = _searchFilteredDogs.where((dog) {
      // Convert dog attributes to lowercase for case-insensitive comparison
      final nameLower = dog.name.toLowerCase();
      final descriptionLower = dog.description.toLowerCase();

      // Apply the search filter
      bool matchesSearch = nameLower.contains(searchLower) ||
          descriptionLower.contains(searchLower);

      // Both conditions (search + filters) must be true
      return matchesSearch;
      // && matchesFilters;
    }).toList();

    setState(() {
      _filteredDogs = filtered;
    });
  }

  void _filterDogs({
    required Set<String> selectedSex,
    required Set<String> selectedSize,
    required Set<String> selectedAge,
    required Set<String> selectedEnergyLevel,
  }) {
    final filtered = _dogs.where((dog) {
      final sexLower = dog.sex.toLowerCase();
      final sizeLower = dog.size.toLowerCase();
      final ageLower = dog.age.toLowerCase();
      final energyLevelLower = dog.energyLevel.toLowerCase();

      final selectedSexLower = selectedSex.map((e) => e.toLowerCase()).toSet();
      final selectedSizeLower =
          selectedSize.map((e) => e.toLowerCase()).toSet();
      final selectedAgeLower = selectedAge.map((e) => e.toLowerCase()).toSet();
      final selectedEnergyLevelLower =
          selectedEnergyLevel.map((e) => e.toLowerCase()).toSet();

      return (selectedSexLower.isEmpty ||
              selectedSexLower.contains(sexLower)) &&
          (selectedSizeLower.isEmpty ||
              selectedSizeLower.contains(sizeLower)) &&
          (selectedAgeLower.isEmpty || selectedAgeLower.contains(ageLower)) &&
          (selectedEnergyLevelLower.isEmpty ||
              selectedEnergyLevelLower.contains(energyLevelLower));
    }).toList();

    setState(() {
      _filteredDogs = filtered;
      _searchFilteredDogs = filtered;
    });
  }

  void _navigateToFilterScreen() async {
    final selectedFilters = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FilterScreen(
          selectedSex: _selectedSex,
          selectedSize: _selectedSize,
          selectedAge: _selectedAge,
          selectedEnergyLevel: _selectedEnergyLevel,
        ),
      ),
    );

    if (selectedFilters != null) {
      setState(() {
        _selectedSex = selectedFilters['sex'] ?? _selectedSex;
        _selectedSize = selectedFilters['size'] ?? _selectedSize;
        _selectedAge = selectedFilters['age'] ?? _selectedAge;
        _selectedEnergyLevel =
            selectedFilters['energyLevel'] ?? _selectedEnergyLevel;
      });

      _filterDogs(
        selectedSex: selectedFilters['sex'],
        selectedAge: selectedFilters['age'],
        selectedSize: selectedFilters['size'],
        selectedEnergyLevel: selectedFilters['energyLevel'],
      );
    } else {
      setState(() {
        _filteredDogs = _dogs;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadDogs();
  }

  Widget _buildDogItem(BuildContext context, int index) {
    Dog dog = _filteredDogs[index];
    return Container(
      margin: const EdgeInsets.only(
          top: 5.0), // añade espacio alrededor del Container
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // la columna solo ocupará el espacio necesario para mostrar su contenido.
          children: [
            ListTile(
              //representa una fila que puede ser interactiva
              onTap: () => _navigateToDogDetails(dog, index),
              leading: Hero(
                //widget que permite animaciones entre pantallas
                tag: index, //debe ser unico
                child: CircleAvatar(
                  backgroundImage: NetworkImage(dog.avatarUrl),
                ),
              ),
              title: Text(
                dog.name,
                /*style: const TextStyle(
                    fontWeight: FontWeight
                        .bold, //grosor del texto, en este caso negrita
                    color: Colors.black,)*/
              ),
              subtitle: Text(dog.description),
              isThreeLine:
                  true, //ajustar texto para mostrar tres lineas de texto
              dense: false, //permite un mayor espacio entre los elementos
            )
          ],
        ),
      ),
    );
  }

  void _navigateToDogDetails(Dog dog, Object avatarTag) {
    Navigator.of(context).push(FadePageRoute(
        builder: (c) {
          //construye el widget que se mostrará en nueva ruta
          return DogDetailsPage(dog,
              avatarTag:
                  avatarTag); // definimos lo que se mostrará en nueva pagina
        },
        settings: const RouteSettings())); //proporciona información adicional
  }

  Widget _getAppTittleWidget() {
    return Text('LISTADO DE PERROS',
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(fontSize: 23.0) // Usa bodyLarge para el texto principal
        /*style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32.0),*/
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
              itemCount: _filteredDogs.length,
              padding: EdgeInsets.zero,
              itemBuilder: _buildDogItem,
            )));
  }

  Widget _buildBody() {
    return Container(
        margin: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 0.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 8.0), // Reduce espacio inferior
              child: _getAppTittleWidget(),
            ),
            /*const SizedBox(
              height: 20,
            ),*/
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? 'Enter an email' : null,
                      onChanged: _filterDogsSearch,
                      decoration: textFieldDecoration.copyWith(
                        //filled: true,
                        //fillColor: Colors.white,
                        hintText: 'Search',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: _navigateToFilterScreen,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.filter_alt,
                          color: Colors.black45,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            _getListViewWidget(),
          ],
        ));
  }

  int _page = 1;
  final AuthService _auth = AuthService();

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.orange,
        //appbar
        appBar: AppBar(
          //backgroundColor: const Color.fromARGB(255, 87, 88, 88),
          elevation: 0.0,
          title: const Text('DogHero'),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (String result) async {
                if (result == 'Salir') {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  await _auth.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreen()),
                  );
                } else if (result == 'Preferencias') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Preferencias()),
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
        body: _buildBody(),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          backgroundColor: const Color.fromARGB(255, 87, 88, 88),
          height: 50.0,
          //placeholder this need to be changed to our color palette
          items: const <Widget>[
            Icon(Icons.list, size: 30, color: Colors.black45),
            Icon(Icons.map, size: 30, color: Colors.black45),
          ],
          onTap: (index) {
            setState(() {
              _page = index;
              if (index == 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Test()),
                );
              } else if (index == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Maps()),
                );
              }
            });
          },
          letIndexChange: (value) => true,
        ));
  }
}
