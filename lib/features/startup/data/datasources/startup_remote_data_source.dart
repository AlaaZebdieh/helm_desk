import '../network/startup_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/safe_api_response.dart';

abstract class StartupRemoteDataSource {
  Future<String> getCountryCode();
}

class StartupRemoteDataSourceImpl implements StartupRemoteDataSource {
  ApiClient apiClient;

  StartupRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<String> getCountryCode() async {
    return safeApiResponse<String>(
      apiClient.get(StartupEndpoints.getCountryCode),
      (json) => json["countryCode"],
    );
  }
}
