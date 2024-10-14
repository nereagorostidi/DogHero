// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:doghero_app/di/app_module.dart' as _i442;
import 'package:doghero_app/di/firebase_service.dart' as _i1023;
import 'package:doghero_app/services/auth_rep.dart' as _i364;
import 'package:doghero_app/services/auth_usecases.dart' as _i755;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

const String _rep = 'rep';
const String _usecases = 'usecases';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    await gh.factoryAsync<_i1023.FirebaseService>(
      () => appModule.firebaseService,
      preResolve: true,
    );
    gh.factory<_i59.FirebaseAuth>(() => appModule.firebaseAuth);
    gh.factory<_i364.AuthRep>(
      () => appModule.authRepository,
      registerFor: {_rep},
    );
    gh.factory<_i755.AuthUsecases>(
      () => appModule.authUsecases,
      registerFor: {_usecases},
    );
    return this;
  }
}

class _$AppModule extends _i442.AppModule {}
