import 'package:get_it/get_it.dart';

import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/is_logged_in_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'presentation/cubit/login_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(loginUsecase: sl()),
  );

  sl.registerLazySingleton<LoginUsecase>(
    () => LoginUsecase(authRepository: sl()),
  );
  sl.registerLazySingleton<LogoutUsecase>(
    () => LogoutUsecase(authRepository: sl()),
  );
  sl.registerLazySingleton<IsLoggedInUsecase>(
    () => IsLoggedInUsecase(authRepository: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );
}
