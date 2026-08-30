import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/startup_repository.dart';

class ChangeThemeUsecase implements Usecase<void, String> {
  final StartupRepository startupRepository;

  ChangeThemeUsecase({required this.startupRepository});

  @override
  Future<Either<Failure, void>> call(String theme) async =>
      await startupRepository.changeTheme(theme);
}
