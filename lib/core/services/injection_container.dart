import 'package:get_it/get_it.dart';
import 'package:snake_empires/features/auth/data/repositories/auth_repository.dart';
import 'package:snake_empires/features/auth/presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  
  // BLoCs
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );
}
