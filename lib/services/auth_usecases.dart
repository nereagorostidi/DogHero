import 'package:doghero_app/services/login_usecases.dart';
import 'package:injectable/injectable.dart';


class AuthUsecases {

  LoginUsecases login;

  AuthUsecases({required this.login});
}