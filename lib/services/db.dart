import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid; // UID único del usuario autenticado

  // Constructor que recibe el UID
  DatabaseService({required this.uid});

  // Referencias a las colecciones en Firestore
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference dogsCollection =
      FirebaseFirestore.instance.collection('dogs');

  // ======================
  // Métodos para actualizar datos
  // ======================

  /// Actualiza los datos del usuario en Firestore
  Future<void> updateUserData({
    required String name,
    required String surname,
    required String location,
    required int phone,
    required String whyAdopt,
    required String makeHappy,
    required String email,
    String? fcmToken,// FCM token opcional
  }) async {
    Map<String, dynamic> userData = {
      'name': name,
      'surname': surname,
      'location': location,
      'phone': phone,
      'whyAdopt': whyAdopt,
      'makeHappy': makeHappy,
      'email': email,
    };

    // Agrega el FCM token si está disponible
    if (fcmToken != null) {
      userData['fcmToken'] = fcmToken;
    }

    // Guarda o actualiza el documento del usuario
    await userCollection.doc(uid).set(userData, SetOptions(merge: true));
  }

  // ======================
  // Getters para obtener datos
  // ======================

  /// Obtiene el nombre del usuario
  Future<String?> getUserName() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['name'] as String?;
      }
      return null;
    } catch (e) {
      print("Error obteniendo el nombre del usuario: $e");
      return null;
    }
  }

  /// Obtiene el apellido del usuario
  Future<String?> getUserSurname() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['surname'] as String?;
      }
      return null;
    } catch (e) {
      print("Error obteniendo el apellido del usuario: $e");
      return null;
    }
  }

  /// Obtiene la ubicación del usuario
  Future<String?> getUserLocation() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['location'] as String?;
      }
      return null;
    } catch (e) {
      print("Error obteniendo la ubicación del usuario: $e");
      return null;
    }
  }

  /// Obtiene el número de teléfono del usuario
  Future<int?> getUserPhone() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['phone'] as int?;
      }
      return null;
    } catch (e) {
      print("Error obteniendo el teléfono del usuario: $e");
      return null;
    }
  }

  /// Obtiene el correo electrónico del usuario
  Future<String?> getUserEmail() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['email'] as String?;
      }
      return null;
    } catch (e) {
      print("Error obteniendo el correo electrónico: $e");
      return null;
    }
  }

  /// Obtiene la razón para adoptar
  Future<String?> getWhyAdopt() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['whyAdopt'] as String?;
      }
      return null;
    } catch (e) {
      print("Error obteniendo la razón para adoptar: $e");
      return null;
    }
  }

  /// Obtiene la explicación de cómo hará feliz al perro
  Future<String?> getMakeHappy() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['makeHappy'] as String?;
      }
      return null;
    } catch (e) {
      print("Error obteniendo la explicación de felicidad: $e");
      return null;
    }
  }

  /// Obtiene el token FCM del usuario
  /// EL token FCM se utiliza para enviar notificaciones push
  Future<String?> getFcmToken() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['fcmToken'] as String?;
      }
      return null;
    } catch (e) {
      print("Error obteniendo el token FCM: $e");
      return null;
    }
  }

  // ======================
  // Métodos relacionados con perros
  // ======================

  /// Actualiza el estado de un perro (adoptado, disponible, etc.)
  Future<bool> updateDogStatus(String dogId, String status) async {
    try {
      DocumentReference dogRef = dogsCollection.doc(dogId);
      await dogRef.update({
        'status': status,
      });
      return true; // Éxito al actualizar
    } catch (e) {
      print('Error actualizando el estado del perro: $e');
      return false; // Error al actualizar
    }
  }

  Future<void> updateDogButtonState(String dogId, bool isEnabled) async {
    try {
      DocumentReference dogDoc =
          FirebaseFirestore.instance.collection('dogs').doc(dogId);
      await dogDoc.update({'buttonEnabled': isEnabled});
      print('El estado del botón se actualizó correctamente.');
    } catch (e) {
      print('Error al actualizar el estado del botón: $e');
      throw Exception('No se pudo actualizar el estado del botón.');
    }
  }

  // Recupera el estado del botón desde Firebase
  Future<bool?> getDogButtonState(String dogId) async {
    var docSnapshot =
        await FirebaseFirestore.instance.collection('dogs').doc(dogId).get();
    return docSnapshot.data()?['buttonEnabled'] as bool?;
  }

  Future<Map<String, dynamic>> getDogData(String dogId) async {
    try {
      DocumentSnapshot dogDoc =
          await FirebaseFirestore.instance.collection('dogs').doc(dogId).get();

      return dogDoc.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error al recuperar los datos del perro: $e');
      return {};
    }
  }

  //Metodo para crear perros
  Future<void> createDog({
    required String name,
    required String age,
    required String color,
    required String description,
    required String sex,
    required String size,
    required List<String> attributes,
    required String imageUrl,
    required String userId,
    required String location,
    required String status,
    required String email,
  }) async {
    try {
      await dogsCollection.add({
        'name': name,
        'age': age,
        'color': color,
        'description': description,
        'sex': sex,
        'size': size,
        'attributes': attributes,
        'image_url': imageUrl,
        'pictures': [imageUrl],
        'id_cuidadora': userId,
        'location': location,
        'timestamp': FieldValue.serverTimestamp(),
        'status': status,
        'donation_contact_email': email,
      });
      print('Dog created successfully');
    } catch (e) {
      print('Error creating dog: $e');
      throw Exception('Failed to create dog');
    }
  }

  // ======================
  // Stream para observar cambios en los datos de usuarios
  // ======================

  /// Obtiene un stream de la colección de usuarios
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }
}
