import '../datasources/shared_remote_data_source.dart';
import '../../domain/repositories/shared_repository.dart';

class SharedRepositoryImpl implements SharedRepository {
  final SharedRemoteDataSource sharedRemoteDataSource;

  SharedRepositoryImpl({required this.sharedRemoteDataSource});
}
