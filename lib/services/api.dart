import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doghero_app/models/dog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DogApi {
  static final FirebaseAuth _auth = FirebaseAuth
      .instance; //Esta instancia permite gestionar la autenticación de usuarios en la aplicación
  static final GoogleSignIn _googleSignIn =
      GoogleSignIn(); //permite gestionar el flujo de inicio de sesión con una cuenta de Google.

  User? firebaseUser; //puede ser null

  DogApi(this.firebaseUser); //pasar un objeto User o null a esta variable.

  static Future<DogApi?> signInWithGoogle() async {
    //static paara no crear instancia
    try {
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn(); //Iniciar sesión con Google
      if (googleUser == null) {
        return DogApi(null); //El usuario canceló la autenticación
      }
      final GoogleSignInAuthentication
          googleAuth = //Autenticación de Google (tokens)
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        //Crear credenciales para Firebase con los tokens obtenidos
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential
          userCredential = //Inicia sesión en Firebase usando las credenciales de Google
          await _auth.signInWithCredential(credential);
      final User? user = userCredential
          .user; //Contiene información sobre el usuario autenticado, como su correo, nombre, etc

      if (user != null) {
        assert(
            user.email != null); //Asegura que el correo del usuario no sea null
        assert(user.displayName !=
            null); //Asegura que el nombre para mostrar del usuario no sea null
        assert(!user
            .isAnonymous); //Asegura que el usuario no sea un usuario anónimo.
        assert(await user.getIdToken() !=
            null); //Verifica que el usuario tenga un token válido de Firebase.

        final User? currentUser = _auth.currentUser;
        assert(user.uid == currentUser?.uid);

        return DogApi(user); //inicio de sesión fue exitoso.
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  static Future<List<Dog>> allDogsFromFirestore() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('dogs').get();

    return snapshot.docs.map((doc) {
      return Dog.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  static List<Dog> allDogsFromJson(String jsonData) {
    //convertimos los datos en formato JSON a una lista de objetos Cat
    List<Dog> dogs = [];
    json.decode(jsonData)['dogs'].forEach((dog) => dogs.add(_fromMap(dog)));
    return dogs;
  }

  static Dog _fromMap(Map<String, dynamic> map) {
    return Dog(
        id: "",
        externalId: map['id'],
        sex: map['sex'],
        color: map['color'],
        breed: map['breed'],
        name: map['name'],
        description: map['description'],
        avatarUrl: map['image_url'],
        location: map['location'],
        likeCounter: map['like_counter'],
        isAdopted: map['adopted'],
        pictures: List<String>.from(map['pictures'] ?? []),
        dogattributes: List<String>.from(map['dogattributes'] ?? []),
        donationContactEmail: map['donation_contact_email'],
        status: map['status'],
        age: map['age'],
        size: map['size'],
        energyLevel: map['energy_level'],
    );
  }
}
