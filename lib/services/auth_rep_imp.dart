import 'package:doghero_app/services/auth_rep.dart';
import 'package:doghero_app/utils/resource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

class AuthRepImp implements AuthRep {
  final FirebaseAuth _firebaseAuth;
  AuthRepImp(this._firebaseAuth);

  @override
  Future<Resource> login(
      {required String email, required String password}) async {
    try {
      UserCredential data = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return Success(data);
    } on FirebaseAuthException catch (e) {
      return Error(e.message ?? "Error al iniciar sesión");
    }
  }
}
