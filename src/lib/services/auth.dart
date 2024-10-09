import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:src/models/user.dart' as dogheroUser;


class AuthService{

  final firebaseAuth.FirebaseAuth _auth = firebaseAuth.FirebaseAuth.instance;

  //creating a user from model/user
  dogheroUser.User? _userfromfirebase(firebaseAuth.User? user) {
  return user != null ? dogheroUser.User(uid: user.uid) : null;
}

//auth change user stream
Stream<dogheroUser.User?> get user {
  return _auth.authStateChanges().map((firebaseAuth.User? user) => _userfromfirebase(user));
}

  
  //sign in with email and pass


  //register with email and pass

  //sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    } catch(e){
      print(e.toString());
      return null;
    }
  }
}