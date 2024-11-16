import 'package:doghero_app/UI/auth/login.dart';
import 'package:doghero_app/services/auth_rep.dart';
import 'package:injectable/injectable.dart';

class LoginUsecases {
  final AuthRep _authRep;

  LoginUsecases(this._authRep);

  launch({required String email, required String password}) =>
      _authRep.login(email: email, password: password);
}
