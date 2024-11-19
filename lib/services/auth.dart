import 'package:doghero_app/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:doghero_app/models/user.dart' as dogheroUser; //alias para evitar ambuiguedad con firebase user


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
  Future signIn(String email, String password) async{
    try {
      firebaseAuth.UserCredential res = await _auth.signInWithEmailAndPassword(email: email, password: password);
      firebaseAuth.User user = res.user!;
      return _userfromfirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  //register with email and pass
  Future register(String email, String password) async{
    try {
      firebaseAuth.UserCredential res = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      firebaseAuth.User user = res.user!;
      await DatabaseService(uid: user.uid).updateUserData(
          name: 'new user',
          surname: '', // Proporciona valores predeterminados
          location: '',
          phone: 0,
          whyAdopt: '', // Proporciona valores predeterminados
          makeHappy: '', // Proporciona valores predeterminados
          fcmToken: null,
          email: '', // Si no tienes un FCM token en este contexto
      );;// missing 1st time check
      print("user created");
      return _userfromfirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

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

