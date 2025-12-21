import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // TODO: Bloc ve Repository kayıtları buraya eklenecek
  
  // External
  sl.registerLazySingleton(() => Hive);
}
