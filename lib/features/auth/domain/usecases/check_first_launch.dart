import '../../data/repositories/auth_repository.dart';

class CheckFirstLaunchUseCase {
  final AuthRepository repository;

  CheckFirstLaunchUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isFirstLaunch();
  }
}
