import 'package:doghero_app/di/firebase_service.dart';
import 'package:doghero_app/services/auth_rep.dart';
import 'package:doghero_app/services/auth_rep_imp.dart';
import 'package:doghero_app/services/auth_usecases.dart';
import 'package:doghero_app/services/login_usecases.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@module 
abstract class AppModule {

  @preResolve
  Future<FirebaseService> get firebaseService => FirebaseService.init();

  @injectable
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @injectable
  AuthRep get authRepository => AuthRepImp(firebaseAuth);

  @injectable
  AuthUsecases get authUsecases => AuthUsecases(
    login: LoginUsecases(authRepository)
  );
}