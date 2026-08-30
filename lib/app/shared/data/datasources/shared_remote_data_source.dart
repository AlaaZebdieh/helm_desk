import '../../../../core/network/api_client.dart';

abstract class SharedRemoteDataSource {}

class SharedRemoteDataSourceImpl implements SharedRemoteDataSource {
  ApiClient apiClient;

  SharedRemoteDataSourceImpl({required this.apiClient});
}
