import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, int number, String location) async{ //check for first time missing
    return await userCollection.doc(uid).set({
      'name': name,
      'location': location,
      'phone': number,
    });
  }

  Future<String?> getUserName() async {
    DocumentSnapshot doc = await userCollection.doc(uid).get();
    return doc['name'];
  }

  //stream to get user data and change it later
  Stream<QuerySnapshot> get users{
    return userCollection.snapshots();
  }
}