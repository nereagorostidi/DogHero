import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, int prefDogSize, String location, bool firstTime) async{
    return await userCollection.doc(uid).set({
      'name': name,
      'prefDogSize': prefDogSize,
      'location': location,
      'firstTime': true,
    });
  }

  //stream to get user data and change it later
  Stream<QuerySnapshot> get users{
    return userCollection.snapshots();
  }
}