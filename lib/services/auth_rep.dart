import 'package:doghero_app/utils/resource.dart';

abstract class AuthRep {
  Future<Resource> login({required String email, required String password});
}