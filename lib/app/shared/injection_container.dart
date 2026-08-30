import 'package:get_it/get_it.dart';
import 'domain/repositories/shared_repository.dart';
import 'data/repositories/shared_repository_impl.dart';
import 'data/datasources/shared_remote_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Use cases

  //! Repository
  sl.registerLazySingleton<SharedRepository>(
    () => SharedRepositoryImpl(sharedRemoteDataSource: sl()),
  );

  //! Data Sources
  sl.registerLazySingleton<SharedRemoteDataSource>(
    () => SharedRemoteDataSourceImpl(apiClient: sl()),
  );
}
