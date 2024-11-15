import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference dogsCollection = FirebaseFirestore.instance.collection('dogs');

  Future updateUserData(String name, int number, String location) async{ //check for first time missing
    return await userCollection.doc(uid).set({
      'name': name,
      'location': location,
      'phone': number,
    });
  }

  Future<String?> getUserName() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      // Check if the document exists and the 'surname' field is present
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return data['name'] ?? ""; // Return empty string if 'surname' is null or absent
      }
      return ""; // Return empty string if the document doesn't exist or has no data
    } catch (e) {
      // Handle any potential errors (e.g., network issues)
      print("Error fetching user surname: $e");
      return "";
    }
  }

  Future<int?> getUserPhone() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      // Check if the document exists and the 'surname' field is present
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return data['phone'] ?? ""; // Return empty string if 'surname' is null or absent
      }
      return 0; // Return empty string if the document doesn't exist or has no data
    } catch (e) {
      // Handle any potential errors (e.g., network issues)
      print("Error fetching user surname: $e");
      return 0;
    }
  }

  Future<String?> getUserEmail() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      // Check if the document exists and the 'surname' field is present
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return data['email'] ?? ""; // Return empty string if 'surname' is null or absent
      }
      return ""; // Return empty string if the document doesn't exist or has no data
    } catch (e) {
      // Handle any potential errors (e.g., network issues)
      print("Error fetching user surname: $e");
      return "";
    }
  }

  Future<String?> getUserSurname() async {
    try {
      DocumentSnapshot doc = await userCollection.doc(uid).get();
      // Check if the document exists and the 'surname' field is present
      if (doc.exists && doc.data() != null) {
        final data = doc.data() as Map<String, dynamic>;
        return data['DSASDSAD'] ?? ""; // Return empty string if 'surname' is null or absent
      }
      return ""; // Return empty string if the document doesn't exist or has no data
    } catch (e) {
      // Handle any potential errors (e.g., network issues)
      print("Error fetching user surname: $e");
      return "";
    }
  }

  //stream to get user data and change it later
  Stream<QuerySnapshot> get users{
    return userCollection.snapshots();
  }

  Future<bool> updateDogStatus(String dogId, String status) async {
    try {
      DocumentReference dogRef = FirebaseFirestore.instance.collection('dogs').doc(dogId.toString());
      await dogRef.update({
        'status': status,
      });
      return true;
    } catch (e) {
      print('Error updating dog status: $e');
      return false;
    }
  }

}