import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doghero_app/UI/dog_list.dart';
import 'package:doghero_app/UI/cuidadora/home_cuidadora.dart';
import 'package:doghero_app/UI/home.dart';
import 'package:doghero_app/UI/test.dart';
import 'package:doghero_app/main.dart';
import 'package:doghero_app/models/user.dart';
import 'package:doghero_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:doghero_app/services/db.dart';
import 'package:provider/provider.dart';
import 'package:doghero_app/UI/preferencias.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final AuthService _auth = AuthService();
  int _page = 1;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  GoogleMapController? mapController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Set<Marker> markers = {};

  Position? currentPosition;
  bool isLoading = true;
  String? errorMessage;
  StreamSubscription<QuerySnapshot>? _protectorasSubscription;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    if (!mounted) return;
    await _determinePosition();
    _subscribeToProtectoras();
  }

  void _subscribeToProtectoras() {
    if (_protectorasSubscription != null) return; // Avoid duplicate subscriptions
    try {
      // Cancel existing subscription if any
      _protectorasSubscription?.cancel();

      // Create new subscription
      _protectorasSubscription = _firestore
          .collection('users')
          .where('role', isEqualTo: 'protectora')
          .snapshots()
          .listen(
        (snapshot) {
          if (_isDisposed || !mounted) return;

          _handleProtectorasSnapshot(snapshot);
        },
        onError: (error) {
          if (_isDisposed || !mounted) return;

          print('Error in protectoras stream: $error');
          setState(() {
            errorMessage = 'Error loading protectoras. Please try again.';
            isLoading = false;
          });
        },
      );
    } catch (e) {
      if (_isDisposed || !mounted) return;

      print('Error setting up protectoras subscription: $e');
      setState(() {
        errorMessage = 'Connection error. Please try again.';
        isLoading = false;
      });
    }
  }

  void _handleProtectorasSnapshot(QuerySnapshot snapshot) {
    try {
      Set<Marker> newMarkers = {};

      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        if (data.containsKey('coords') && data['coords'] != null) {
          GeoPoint coords = data['coords'] as GeoPoint;

          final marker = Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(coords.latitude, coords.longitude),
            infoWindow: InfoWindow(
              title: data['name'] ?? 'Protectora',
              snippet: data['description'] ?? '',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          );

          newMarkers.add(marker);
        }
      }

      if (!_isDisposed && mounted) {
        setState(() {
          markers = newMarkers;
          isLoading = false;
          errorMessage = null;
        });
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        setState(() {
          errorMessage = 'Error processing data. Please try again.';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _determinePosition() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      Position position = await _getCurrentLocation();
      if (!mounted) return;

      setState(() {
        currentPosition = position;
        isLoading = false;
      });

      if (mapController != null && mounted) {
        await mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled. Please enable them in your device settings.';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied. Please enable them in your device settings.';
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw 'Error getting location: $e';
    }
  }

  void _handleNavigation(int index, BuildContext context) {
    if (index == _page) return;

    Widget nextScreen;
    switch (index) {
      case 0:
        nextScreen = Test();
        break;
      case 1:
        nextScreen = const Maps();
        break;
      default:
        return;
    }

    _cleanupResources();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
      (route) => false,
    );
  }

  void _cleanupResources() {
    _protectorasSubscription?.cancel();
    if (mapController != null) {
      mapController!.dispose(); // Dispose the map controller explicitly
      mapController = null;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _cleanupResources();
    super.dispose();
  }

  Widget _buildMapContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    } else {
      return GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          zoom: 15,
        ),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        markers: markers,
        onMapCreated: (controller) {
          mapController = controller;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: _auth.user,
      initialData: null,
      catchError: (_, __) => null,
      child: Consumer<User?>(
        builder: (context, user, _) {
          return StreamProvider<QuerySnapshot?>.value(
            value: user != null ? DatabaseService(uid: user.uid).users : null,
            initialData: null,
            catchError: (_, __) => null,
            child: WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                appBar: AppBar(
                  elevation: 0.0,
                  title: const Text('DogHero'),
                  actions: <Widget>[
                    PopupMenuButton<String>(
                      onSelected: (String result) async {
                        if (result == 'Salir') {
                          _cleanupResources(); // Ensure cleanup of resources
                          Navigator.of(context).popUntil((route) => route.isFirst);
                          await _auth.signOut();
                        } else if (result == 'Preferencias') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Preferencias()),
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
                      child: _buildMapContent(),
                    ),
                    CurvedNavigationBar(
                      key: _bottomNavigationKey,
                      index: _page,
                      animationDuration: const Duration(milliseconds: 200),
                      backgroundColor: const Color.fromARGB(255, 87, 88, 88),
                      height: 50.0,
                      items: const <Widget>[
                        Icon(Icons.list, size: 30, color: Colors.black45),
                        Icon(Icons.map, size: 30, color: Colors.black45),
                      ],
                      onTap: (index) => _handleNavigation(index, context),
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
